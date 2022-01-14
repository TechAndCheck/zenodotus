require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  test "creating an organization without a name fails" do
    assert_raises ActiveRecord::NotNullViolation do
      Organization.create!({ admin: User.first })
    end
  end

  test "creating an organization works" do
    assert_nothing_raised do
      Organization.create!({ name: "Test Org", admin: User.first })
    end
  end

  test "organization has users" do
    assert Organization.first.users.count.positive?
  end

  test "an organization with users but no admin raises an error" do
    organization = Organization.create!({ name: "Test Org" })
    organization.users << User.first

    assert_raises Organization::NoAdminError do
      organization.save!
    end
  end
end
