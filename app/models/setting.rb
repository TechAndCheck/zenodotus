# RailsSettings Model
class Setting < RailsSettings::Base
  cache_prefix { "v1" }

  # Define your fields
  field :google_feed_last_updated, type: :string, default: "1970-01-01T00:00:00+00:00"
  field :fact_check_insights_json_url, type: :string, default: nil
end
