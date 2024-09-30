# typed: strict


# NOTE: This now uses Postgres for searching, which is very very quick.
# However, a significant amount of the slow down is the FFMPEG processing itself. I wonder if using
# Lambda such as described here https://aws.amazon.com/blogs/media/processing-user-generated-content-using-aws-lambda-and-ffmpeg/
# may speed this up since we can throw a huge instance at a very short-lived process?

class ImageSearch < ApplicationRecord
  # class GoogleSearchResult
  #   # TODO: Move this to a active record model instead
  #   attr_reader :text, :claimant, :claim_date, :url, :review_date, :rating, :language_code, :publisher_name, :publisher_site, :title
  #   attr_accessor :image_url

  #   def initialize(google_object)
  #     @text = google_object["text"]
  #     @claimant = google_object["claimant"]
  #     @claim_date = DateTime.parse(google_object["claimDate"]) unless google_object["claimDate"].nil?
  #     @url = google_object["claimReview"].first["url"]
  #     @review_date = DateTime.parse(google_object["claimReview"].first["reviewDate"]) unless google_object["claimReview"].first["reviewDate"].nil?
  #     @rating = google_object["claimReview"].first["textualRating"]
  #     @title = google_object["claimReview"].first["title"]
  #     @language_code = google_object["claimReview"].first["languageCode"]
  #     @publisher_name = google_object["claimReview"].first["publisher"]["name"]
  #     @publisher_site = google_object["claimReview"].first["publisher"]["site"]
  #     @image_url = nil
  #   end

  #   def image_file
  #     Rails.cache.fetch("#{@url}/#{@image_url}", expires_in: 30.seconds) do
  #       hydra = Typhoeus::Hydra.hydra
  #       request = Typhoeus::Request.new(@image_url, followlocation: true) }
  #       hydra.queue(request)
  #       hydra.run

  #       request.response.body
  #     end
  #   end
  # end


  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute
  include VideoUploader::Attachment(:video)

  include Dhashable

  belongs_to :user, optional: false, class_name: "User"

  after_commit on: [:create] do
    # We only want to create the derivatives once (since you know, it's a media archive we don't
    # want them to change)
    self.video_derivatives! unless self.video.nil?
  end

  before_save do
  end

  # Implemented for Dhashable to find so that only certain number of frames of video are hashed
  # when searching
  sig { returns(Integer) }
  def limit_video_frames_hashed
    8
  end

  sig { params(media_item: T.any(ActionDispatch::Http::UploadedFile, Tempfile, File), current_user: User, private: T::Boolean).returns(ImageSearch) }
  def self.create_with_media_item(media_item, current_user, private = false)
    mime = IO.popen(
      ["file", "--brief", "--mime-type", media_item.path],
      in: :close, err: :close
    ) { |io| io.read.chomp }

    search =  case mime.split("/").first
              when "video"
                ImageSearch.create!({ video: media_item, user: current_user, private: private })
              when "image"
                ImageSearch.create!({ image: media_item, user: current_user, private: private })
              else
                raise "Invalid media uploaded."
    end

    search
  end

  # Runs the search against all images in the database given the +image+ attached
  #
  # @return An ordered array of the search results with the format
  # { image: ArchiveItem, distance: Float } Note that the lower the distance the better the match
  # as this meaning the hamming distance between the images is less.
  sig { returns(T::Array[T::Hash[ArchiveItem, Float]]) }
  def run
    if self.image.nil? == false
      # Currently we run two queries, the first gets raw, then we change that into proper objects
      raw_sql = raw_sql(self.dhashes.first)

      archive_items_raw = ArchiveItem.connection.select_all(raw_sql)
      archive_items = ArchiveItem.find(archive_items_raw.rows.map(&:first))

      images = archive_items.map.with_index do |archive_item, index|
        { image: archive_item, distance: archive_items_raw[index]["levenshtein"] }
      end

      archive_final_items = images
      google_items = search_google_by_media(self.image_url)
    else
      # For videos we have to loop
      archive_items_raw = self.dhashes.flat_map do |dhash|
        raw_sql = raw_sql(dhash["dhash"])
        ArchiveItem.connection.select_all(raw_sql).rows
      end

      archive_items = ArchiveItem.find(archive_items_raw.map(&:first))

      videos = archive_items.map.with_index do |archive_item, index|
        { video: archive_item, distance: archive_items_raw[index][1] }
      end

      # Videos are now sorted by distance, but we want to only keep the shortest distance
      # Probably can get this into the sql above
      videos.uniq! { |video_hash| video_hash[:video] }
      archive_final_items = videos
      google_items = search_google_by_media(self.video_derivatives[:preview].url)
    end

    [archive_final_items, google_items]
  end


  # TODO: Add paging
  sig { params(dhash: String).returns(String) }
  def raw_sql(dhash)
    inner_query = %{SELECT DISTINCT ON (archive_items.archivable_item_id) *, levenshtein(dhash, '#{dhash}')
                    FROM image_hashes
                    INNER JOIN archive_items ON archive_items.id = image_hashes.archive_item_id
                    WHERE levenshtein(dhash, '#{dhash}') < 20
                    AND private = #{self.private}
                  }

    if self.private
      inner_query = "#{inner_query} AND submitter_id = '#{self.user.id}'"
    end

    sql = "SELECT archive_item_id, levenshtein FROM ( #{inner_query} ) t ORDER BY levenshtein LIMIT 20;"
    sql = sql.split("\n").map(&:strip).join(" ")

    Rails.logger.info("\n**********************************************************************")
    Rails.logger.info(sql)
    Rails.logger.info("**********************************************************************\n")

    sql
  end

private

  sig { params(image_url: String).returns(T::Array[GoogleSearchResult]) }
  def search_google_by_media(image_url)
    request = build_google_search_request(image_url, image: true)
    response = request.run
    response_body = JSON.parse(response.response_body)

    return [] if response_body["results"].nil?
    results = response_body["results"].map { |google_object| GoogleSearchResult.from_api_response(google_object["claim"]) }

    hydra = Typhoeus::Hydra.hydra
    requests = results.map { |result| Typhoeus::Request.new(
      result.url, followlocation: true,
      headers: { "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 14_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.0 Safari/605.1.15" }
    ) }
    requests.each { |request| hydra.queue(request) }
    hydra.run

    requests.each_with_index.map do |request, index|
      image_elements = Nokogiri::HTML.parse(request.response.body).xpath('//meta[@property="og:image"]')
      image_url = image_elements.first.values[1] unless image_elements.empty?
      results[index].update(image_url: image_url)
    end

    results
  end

  sig { params(query: String, image: T::Boolean).returns(Typhoeus::Request) }
  def build_google_search_request(query, image: false)
    url = "https://factchecktools.googleapis.com/v1alpha1/claims:imageSearch"
    params = { imageUri: query, key: Figaro.env.FACTCHECK_TOOLS_API_KEY }

    Typhoeus::Request.new(
      url,
      method: :get,
      params: params,
      headers: { Accept: "text/html" }
    )
  end
end
