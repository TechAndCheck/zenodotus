# typed: ignore

class VideoUploader < Shrine
  Attacher.derivatives do |original|
    preview = Tempfile.new ["#{SecureRandom.uuid}-preview", ".jpg"]

    video = FFMPEG::Movie.new(original.path)
    video.screenshot(preview.path)

    { preview: preview }
  end
end
