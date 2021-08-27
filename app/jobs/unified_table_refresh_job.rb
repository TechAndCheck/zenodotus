class UnifiedTableRefreshJob < ApplicationJob
  queue_as :default

  def perform(*args)
    UnifiedUser.refresh
    UnifiedPost.refresh
    puts "***********************************"
    puts "using job"
    puts "***********************************"
  end
end
