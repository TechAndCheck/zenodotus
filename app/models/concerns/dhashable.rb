# typed: false
# require "dhash-vips"

module Dhashable
  extend ActiveSupport::Concern

  included do
    before_save :generate_dhash
  end

  # Returns whether the object is a image attachment type or a video attachment type
  #
  # @return a symbol telling which type of attachment this is
  sig { returns(Symbol) }
  def attachment_type
    return :video unless self.image.nil?
    return :image unless self.video.nil?

    raise "Unable to determine type of attachment. You shouldn't be seeing this."
  end

  def generate_dhash
    self.image.open
    tempfile_path = image.tempfile.path
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

    self.image.close

    ####
    ## NOTE This is where i left it, going to have to write some tests here
    # => Also drop the dhash property of this
    ####
  end
end
