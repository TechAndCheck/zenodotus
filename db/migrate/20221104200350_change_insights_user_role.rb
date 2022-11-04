class ChangeInsightsUserRole < ActiveRecord::Migration[7.0]
  def up
    # See https://github.com/TechAndCheck/zenodotus/issues/433
    Role.where(name: "insights_user").update(name: "fact_check_insights_user")
  end

  def down
    Role.where(name: "fact_check_insights_user").update(name: "insights_user")
  end
end
