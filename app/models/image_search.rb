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

  sig { params(media_item: ActionDispatch::Http::UploadedFile, current_user: User).returns(ImageSearch) }
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
  # Right now this is very very slow due to it doing all the dhashing in Ruby. We can probably move
  # this to the database in a function eventually.
  #
  # @return An ordered array of the search results with the format
  # { image: ArchiveItem, score: Float }
  sig { returns(T::Array[T::Hash[ArchiveItem, Float]]) }
  def run
    # For images, we do our thing
    if self.image.nil? == false
      image_hashes = Zelkova.graph.search(self.dhashes.first)

      # For videos we have to loop


      images = image_hashes.map do |image_hash|
        hash = ImageHash.find(image_hash[:node].metadata[:id])
        { image: hash.archive_item, score: image_hash[:distance] }
      end

      images
    else
      video_hashes = []
      self.dhashes.each do |dhash|
        video_hashes = video_hashes | Zelkova.graph.search(dhash["dhash"])
      end

      videos = video_hashes.map do |video_hash|
        hash = ImageHash.find(video_hash[:node].metadata[:id])
        { video: hash.archive_item, score: video_hash[:distance] }
      end

      videos.sort_by! { |video| video[:score] }
      videos
    end
  end
end
