require "test_helper"

class ScrapeTest < ActiveSupport::TestCase
  test "can create scrape" do
    assert_not_nil Scrape.create!({
      url: "https://www.instagram.com/p/Cgu8NH6usai/?utm_source=ig_web_copy_link",
      scrape_type: :instagram
    })
  end
end
