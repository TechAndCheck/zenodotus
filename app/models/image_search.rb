# typed: strict


# NOTE: This now uses Postgres for searching, which is very very quick.
# However, a significant amount of the slow down is the FFMPEG processing itself. I wonder if using
# Lambda such as described here https://aws.amazon.com/blogs/media/processing-user-generated-content-using-aws-lambda-and-ffmpeg/
# may speed this up since we can throw a huge instance at a very short-lived process?

class ImageSearch < ApplicationRecord
  include ImageUploader::Attachment(:image) # adds an `image` virtual attribute
  include VideoUploader::Attachment(:video)

  include Dhashable

  belongs_to :user, optional: false, class_name: "User"

  after_commit on: [:create] do
    # We only want to create the derivatives once (since you know, it's a media archive we don't
    # want them to change)
    self.video_derivatives! unless self.video.nil?
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
      # Currently we run the query twice (speed at our scale is quite easy)
      # We do this so we can get the proper distance in the result

      sql = sql(self.dhashes.first)
      raw_sql = raw_sql(self.dhashes.first)

      image_hashes = ImageHash.find_by_sql(sql)
      image_hashes_raw = ImageHash.connection.select_all(raw_sql)

      images = image_hashes.map.with_index do |image_hash, index|
        { image: image_hash.archive_item, distance: image_hashes_raw[index]["levenshtein"] }
      end

      images
    else
      # For videos we have to loop
      video_hashes = []
      video_hashes_raw = []
      self.dhashes.each do |dhash|
        sql = sql(dhash["dhash"])
        raw_sql = raw_sql(dhash["dhash"])

        video_hashes += ImageHash.find_by_sql(sql)
        video_hashes_raw += ImageHash.connection.select_all(raw_sql)
      end

      videos = video_hashes.map.with_index do |video_hash, index|
        { video: video_hash.archive_item, distance: video_hashes_raw[index]["levenshtein"] }
      end

      # Videos are now sorted by distance, but we want to only keep the shortest distance
      # Probably can get this into the sql above
      videos.uniq! { |video_hash| video_hash[:video] }

      videos
    end
  end

  sig { params(dhash: String).returns(String) }
  def sql(dhash)
    sql = "SELECT * FROM image_hashes INNER JOIN archive_items ON archive_items.id = image_hashes.archive_item_id  WHERE levenshtein(dhash, '#{dhash}') < 20"

    if self.private
      sql += " AND submitter_id = '#{self.user.id}'"
    end

    sql += " AND private = #{self.private} ORDER BY levenshtein(dhash, '#{dhash}');"

    sql
  end

  sig { params(dhash: String).returns(String) }
  def raw_sql(dhash)
    raw_sql = "SELECT *, levenshtein(dhash, '#{dhash}') FROM image_hashes INNER JOIN archive_items ON archive_items.id = image_hashes.archive_item_id  WHERE levenshtein(dhash, '#{dhash}') < 20"

    if self.private
      raw_sql += " AND submitter_id = '#{self.user.id}'"
    end

    raw_sql += " AND private = #{self.private} ORDER BY levenshtein(dhash, '#{dhash}');"

    raw_sql
  end
end
