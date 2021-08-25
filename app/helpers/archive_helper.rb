# typed: strict
module ArchiveHelper
  def prepend_uploads_folder(filename)
    "/uploads/#{filename}"
  end
end
