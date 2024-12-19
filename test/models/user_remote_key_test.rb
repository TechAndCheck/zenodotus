require "test_helper"

class UserRemoteKeyTest < ActiveSupport::TestCase
  test "can create remote key" do
    user = users(:user)
    remote_key = UserRemoteKey.create(user: user)

    assert remote_key.valid?
    assert remote_key.key_valid?
    assert remote_key.expires_at
    assert remote_key.hashed_remote_key
  end

  test "can find remote key by key" do
    user = users(:user)
    remote_key = UserRemoteKey.create(user: user)

    found_remote_key = UserRemoteKey.find_by_remote_key(remote_key.remote_key)
    assert_equal remote_key, found_remote_key
  end

  test "found remote key doesn't contain plaintext key" do
    user = users(:user)
    remote_key = UserRemoteKey.create(user: user)

    found_remote_key = UserRemoteKey.find_by_remote_key(remote_key.remote_key)
    assert_not found_remote_key.remote_key

    assert remote_key.key_valid?
  end

  test "can expire remote key" do
    user = users(:user)
    remote_key = UserRemoteKey.create(user: user)
    remote_key.expire_now
    assert remote_key.expired?
  end

  test "can use remote key" do
    user = users(:user)
    remote_key = UserRemoteKey.create(user: user)
    remote_key.use("127.0.0.1", "Mozilla/5.0", "http://localhost", "http://localhost", "/users/sign_in", "POST")
    assert remote_key.key_valid?
    assert remote_key.last_used_at
    assert remote_key.last_used_ip
    assert remote_key.last_used_user_agent
    assert remote_key.last_used_referer
    assert remote_key.last_used_origin
    assert remote_key.last_used_path
    assert remote_key.last_used_method
  end

  test "can't use expired remote key" do
    user = users(:user)
    remote_key = UserRemoteKey.create(user: user)
    remote_key.expire_now
    assert_not remote_key.use("127.0.0.1", "Mozilla/5.0", "http://localhost", "http://localhost", "/users/sign_in", "POST")
  end

  test "Current remote keys are invalidated when new one is created for a users" do
    user = users(:user)
    remote_key_1 = UserRemoteKey.create(user: user)
    assert remote_key_1.key_valid?

    remote_key_2 = UserRemoteKey.create(user: user)
    assert remote_key_2.key_valid?

    remote_key_1.reload
    assert remote_key_1.expired?
  end

  test "can't create remote key without user" do
    remote_key = UserRemoteKey.new
    assert_not remote_key.save
  end

  test "can expire key" do
    user = users(:user)
    remote_key = UserRemoteKey.create(user: user)
    remote_key.expire_now
    assert remote_key.expired?

    assert_not remote_key.use("127.0.0.1", "Mozilla/5.0", "http://localhost", "http://localhost", "/users/sign_in", "POST")
  end
end
