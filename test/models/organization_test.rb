require "test_helper"

class OrganizationTest < ActiveSupport::TestCase
  test "creating an organization without an admin fails" do
    assert_raises ActiveRecord::RecordInvalid do
      Organization.create!({ name: "Test Org" })
    end
  end

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
end
