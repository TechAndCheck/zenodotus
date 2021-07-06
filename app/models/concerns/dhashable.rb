# typed: false
require "dhash-vips"

module Dhashable
  extend ActiveSupport::Concern

  included do
    before_save :generate_dhash
  end

  def generate_dhash
    self.image.open
    tempfile_path = image.tempfile.path
    self.dhash = DHashVips::DHash.calculate tempfile_path

    # This is commented out because otherwise it causes an error when uploading it up
    # Let's hope it doesn't cause memory leaks
    # self.image.close
  end
end
