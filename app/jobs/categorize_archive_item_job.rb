class CategorizeArchiveItemJob < ApplicationJob
  queue_as :default

  def perform(archive_item)
    archive_item.categorize!
  end
end
