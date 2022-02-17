require "test_helper"

class ImageSearchTest < ActiveSupport::TestCase
  def setup
    file = File.open("test/fixtures/files/instagram_image_test.jpg", binmode: true)
    @image_search = ImageSearch.create(image: file)
  end

  test "can create image search" do
    assert_not_nil @image_search
    assert_not_nil @image_search.image
    assert_not_nil @image_search.dhash
  end

  test "can run image search" do
    # First we need to create a few posts. The Shrine fixture way doesn't seem to actually work.
    Sources::InstagramPost.create_from_url!("https://www.instagram.com/p/CBcqOkyDDH8/?utm_source=ig_embed")
    Sources::InstagramPost.create_from_url!("https://www.instagram.com/p/CQDeYPhMJLG/")
    Sources::InstagramPost.create_from_url!("https://www.instagram.com/p/CBZkDi1nAty/?utm_source=ig_embed")
    Sources::InstagramPost.create_from_url!("https://www.instagram.com/p/CZ3_P6FrtMO/")
    results = @image_search.run

    assert_not_nil results

    # Make sure everything is in order
    in_order = true
    results.each_with_index do |result, index|
      # End if we have nothing to compare to (we're at the end)
      break if index == results.length - 1
      # Do the comparison
      if result[:score] > results[index + 1][:score]
        in_order = false
        break
      end
    end
    assert in_order, "Images should be returned in order of similarity (lower is better)"
    assert_equal 1, results.first[:score], "First image should be equal to passed in image"
  end
end
