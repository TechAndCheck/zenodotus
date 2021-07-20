# typed: ignore

# Update all twitter videos to have a preview image
class CreateTwitterVideoPreview < ActiveRecord::Migration[6.1]
  def change
    Source::Tweet.all do |tweet|
      tweet.videos.each { |video| video.video_derivatives! }
    end
  end
end
