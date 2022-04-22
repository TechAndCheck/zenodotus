# typed: false

module Dhashable
  extend ActiveSupport::Concern
  extend T::Sig

  included do
    before_save :generate_single_dhash
    after_save :generate_dhashes_for_attached_media
  end

  # Returns whether the object is a image attachment type or a video attachment type
  #
  # @return a symbol telling which type of attachment this is
  sig { returns(Symbol) }
  def attachment_type
    return :video if self.archivable_item.respond_to?("videos") && !self.videos.empty?
    return :image if self.archivable_item.respond_to?("images") && !self.images.empty?

    raise "Unable to determine type of attachment. You shouldn't be seeing this."
  end

  def generate_dhashes_for_attached_media
    return unless self.respond_to?(:archivable_item)

    media_items = attachment_type == :image ? self.archivable_item.images : self.archivable_item.videos
    media_items.each do |media_item|
      media_item = self.attachment_type == :image ? media_item.image : media_item.video

      # TODO: refactor this so it's all the same, since it *mostly* is
      media_item.open
      tempfile_path = media_item.tempfile.path

      dhashes = nil

      case self.attachment_type
      when :image
        dhashes = [Eikon.dhash_for_image(tempfile_path)]
      when :video
        dhashes = Eikon.dhash_for_video(tempfile_path)
      end

      dhashes.map do |dhash|
        ImageHash.create!({
          dhash: dhash,
          archive_item: self
        })
      end

      media_item.close
    end
    ####
    # Add video and test for such
    # => Also drop the dhash property of this
    ####
  end

  def generate_single_dhash
    return unless self.respond_to?(:dhash)

    self.image.open
    tempfile_path = self.image.tempfile.path
    self.dhash = Eikon.dhash_for_image(tempfile_path)
  end
end
