require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user has organization" do
    assert User.first.organization.nil? == false
  end

  test "user cannot be destroyed if admin of an organization" do
    assert_raises User::DontDestroyIfAdminError do
      User.first.destroy!
    end
  end

  test "user can be destroyed if not an admin" do
    organization = Organization.where(name: "Test Organization").first
    first_user = organization.users.first

    assert_raises User::DontDestroyIfAdminError do
      first_user.destroy!
    end

    organization.update({ admin: organization.users.second })

    assert_nothing_raised do
      first_user.destroy!
    end
  end
end
