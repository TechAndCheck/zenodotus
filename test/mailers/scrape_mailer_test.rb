require "test_helper"

class ScrapeMailerTest < ActionMailer::TestCase
  test "invite" do
    # Create the email and store it for further assertions
    email = ScrapeMailer.with(url: "https://www.example.com", user: { email: "friend@example.com" }).scrape_complete_email

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    assert_equal ["no-reply@mail.factcheckinsights.com"], email.from
    assert_equal ["friend@example.com"], email.to
  end
end
