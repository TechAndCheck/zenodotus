class UserRemoteKey < ApplicationRecord
  validates :expires_at, presence: true
  validates :hashed_remote_key, uniqueness: true
  validates :user, presence: true

  before_validation :set_remote_key, :set_expiry

  belongs_to :user

  attr_reader :remote_key

  def self.find_by_remote_key(remote_key)
    hashed_remote_key = ZenoEncryption.hash_string(remote_key)
    UserRemoteKey.find_by(hashed_remote_key: hashed_remote_key)
  end

  def expire_now
    self.update!(expires_at: Time.now)
  end

  def expired?
    Time.now >= self.expires_at
  end

  def key_valid?
    !expired?
  end

  def use(ip, user_agent, referer, origin, path, method)
    return false if expired?

    self.last_used_at = Time.now
    self.last_used_ip = ip
    self.last_used_user_agent = user_agent
    self.last_used_referer = referer
    self.last_used_origin = origin
    self.last_used_path = path
    self.last_used_method = method
    true
  end

  def update_with_use(request)
    use(
      request.remote_ip,
      request.user_agent,
      request.referer,
      request.origin,
      request.path,
      request.method
    )
  end

private

  def set_remote_key
    if self.new_record?
      @remote_key = SecureRandom.hex(32)
      self.hashed_remote_key = ZenoEncryption.hash_string(self.remote_key)
    end
  end

  def set_expiry
    if self.new_record?
      UserRemoteKey.where(user: self.user, expires_at: Time.now..DateTime::Infinity.new).in_batches.update_all(expires_at: Time.now)
      self.expires_at = 1.month.from_now
    end
  end
end
