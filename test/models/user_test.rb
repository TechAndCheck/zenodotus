require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user has organization" do
    assert User.first.organization.nil? == false
  end

  test "user cannot be destroyed if admin of an organization" do
    assert_raises User::DontDestroyIfAdminError do
      user = Organization.first.admin
      user.destroy!
    end
  end

  test "user can be destroyed if not an admin" do
    organization = Organization.where(name: "Test Organization").first
    # Get a user that's not an admin
    nonadmin_user = nil
    organization.users.each do |user|
      next if organization.admin == user

      nonadmin_user = user
      break
    end

    admin_user = organization.admin
    assert_raises User::DontDestroyIfAdminError do
      organization.admin.destroy!
    end

    organization.update({ admin: nonadmin_user })

    assert_nothing_raised do
      admin_user.destroy!
    end
  end
end
