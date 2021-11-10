class UnifiedTableRefreshJob < ApplicationJob
  queue_as :default

  def perform(*args)
    UnifiedUser.refresh
    UnifiedPost.refresh
  end
end
