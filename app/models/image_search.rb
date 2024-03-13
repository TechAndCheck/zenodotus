# typed: strict

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

  sig { params(media_item: T.any(ActionDispatch::Http::UploadedFile, Tempfile, File), current_user: User).returns(ImageSearch) }
  def self.create_with_media_item(media_item, current_user)
    mime = IO.popen(
      ["file", "--brief", "--mime-type", media_item.path],
      in: :close, err: :close
    ) { |io| io.read.chomp }

    search =  case mime.split("/").first
              when "video"
                ImageSearch.create!({ video: media_item, user: current_user })
              when "image"
                ImageSearch.create!({ image: media_item, user: current_user })
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
      image_hashes = ImageHash.find_by_sql("SELECT * FROM image_hashes WHERE levenshtein(dhash, '#{self.dhashes.first}') < 20 ORDER BY levenshtein(dhash, '#{self.dhashes.first}');")
      image_hashes_raw = ImageHash.connection.select_all("SELECT *, levenshtein(dhash, '#{self.dhashes.first}') FROM image_hashes WHERE levenshtein(dhash, '#{self.dhashes.first}') < 20 ORDER BY levenshtein(dhash, '#{self.dhashes.first}');")

      images = image_hashes.map.with_index do |image_hash, index|
        { image: image_hash.archive_item, distance: image_hashes_raw[index]["levenshtein"] }
      end

      images
    else
      # For videos we have to loop
      video_hashes = []
      video_hashes_raw = []
      self.dhashes.each do |dhash|
        video_hashes += ImageHash.find_by_sql("SELECT * FROM image_hashes WHERE levenshtein(dhash, '#{dhash["dhash"]}') < 20 ORDER BY levenshtein(dhash, '#{dhash["dhash"]}');")
        video_hashes_raw += ImageHash.connection.select_all("SELECT *, levenshtein(dhash, '#{dhash["dhash"]}') FROM image_hashes WHERE levenshtein(dhash, '#{dhash["dhash"]}') < 20 ORDER BY levenshtein(dhash, '#{dhash["dhash"]}');")
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
end
