require "test_helper"

class ApiKeyTest < ActiveSupport::TestCase
  test "creating an api key returns the clear string of the key" do
    api_key = ApiKey.create(user: users(:user1))
    assert_not_nil api_key.api_key
    assert_not_nil api_key.hashed_api_key
  end

  test "retrieving an api key does not return the clear string of the key" do
    api_key = ApiKey.create(user: users(:user1))
    api_key = ApiKey.find(api_key.id)
    assert_nil api_key.api_key
    assert_not_nil api_key.hashed_api_key
  end

  test "deleting a user deletes all of its api keys" do
    user = users(:user3)
    api_key = ApiKey.create(user: user)
    assert_not_nil api_key
    user.destroy!
    assert_raise(ActiveRecord::RecordNotFound) do
      ApiKey.find(api_key.id)
    end
  end
end
