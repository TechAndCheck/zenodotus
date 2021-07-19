# typed: ignore
require "test_helper"

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "can properly determine model for url" do
    assert_equal Sources::InstagramPost, ApplicationController.new().model_for_url("https://www.instagram.com/p/CBcqOkyDDH8/?utm_source=ig_embed")
    assert_equal Sources::Tweet, ApplicationController.new().model_for_url("https://twitter.com/AmtrakNECAlerts/status/1397922363551870990")
  end
end
