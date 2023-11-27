class AddHeartbeatForScrapableSite < ActiveRecord::Migration[7.0]
  def change
    add_column :scrapable_sites, :last_heartbeat_at, :datetime, defualt: nil
    add_column :scrapable_sites, :last_run_finished_at, :datetime, defualt: nil
  end
end
