require "test_helper"

class MediaVault::MediaControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper
  include Devise::Test::IntegrationHelpers
  include Minitest::Hooks

  def around
    AwsS3Downloader.stub(:download_file_in_s3_received_from_hypatia, S3_MOCK_STUB) do
      super
    end
  end


  setup do
    host! Figaro.env.MEDIA_VAULT_HOST
  end

  test "cannot view media if not logged in" do
    get media_vault_medium_path(id: "abc123")
    assert_redirected_to new_user_session_path
  end

  # TODO: Fix this eventually. Until then just download the metadata and check it manually on the site
  # test "can export media item metadata" do
  #   user = users(:user)
  #   sign_in user

  #   media_review_json = '{
  #         "@context" : "http://schema.org",
  #         "@type" : "MediaReview",
  #         "author" :
  #         {
  #           "@type" : "Organization",
  #           "name" : "Fact Crescendo",
  #           "url" : "https://cambodia.factcrescendo.com/"
  #         },
  #         "datePublished" : "2023-05-26",
  #         "itemReviewed" :
  #         {
  #           "@type" : "ImageObject",
  #           "contentUrl" : "https://www.facebook.com/Cambodiatruenews/posts/pfbid0LsS4mwCSiafVsUjhmSdMRNufyJxmuVpX5nnsLprVxuBSpctmvxrshNXRa3d9jCWMl"
  #         },
  #         "mediaAuthenticityCategory" :
  #         [
  #           "TransformedContent"
  #         ],
  #         "originalMediaContextDescription" : "The original photo depicts Cambodian Army Chief Hun Manet \u2013 Prime Minister Hun Sen\u2019s oldest son \u2013 carrying the Cambodian flag and walking in a military parade in early 2019.",
  #         "originalMediaLink" : "https://royalcambodiaarmy.blogspot.com/2019/01/blog-post_23.html",
  #         "sdPublisher" :
  #         {
  #           "@type" : "Organization",
  #           "name" : "Google Fact Check Tools",
  #           "url" : "https://g.co/factchecktools"
  #         },
  #         "url" : "https://cambodia.factcrescendo.com/english/a-photo-of-hun-manet-carrying-the-vietnamese-flag-digitally-edited/"
  #       }'

  #   archive_item = ArchiveItem.create_from_media_review(JSON.parse(media_review_json), nil)
  #   archive_item.save!
  #   debugger
  #   get media_vault_export_media_metadata_path(archive_item.id)
  #   assert_response :success
  #   assert_equal "application/json", response.content_type

  #   json = JSON.parse response.body
  #   assert json.has_key?("archivable_item")
  # end

  # TODO: Make this test work by ensuring we have ArchiveItem fixtures
  # test "can view individual piece of media" do
  #   sign_in users(:media_vault_user)

  #   archive_item = ArchiveItem.first

  #   get media_vault_medium_path(archive_item)
  #   assert_response :success
  # end
end
