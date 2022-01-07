require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user has organization" do
    assert User.first.organization.nil? == false
  end
end
