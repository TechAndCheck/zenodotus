class ScraperJob < ApplicationJob
  queue_as :default

  def perform(media_source_class, media_model, url)
    media_item = media_source_class.extract(url)
    media_model.create_from_hash(media_item)
  end
end
