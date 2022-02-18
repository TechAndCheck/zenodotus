# typed: strict

class ApiKey < ApplicationRecord
  belongs_to :user, required: true
  attr_reader :api_key

  before_create :create_api_key

  sig { void }
  def create_api_key
    @api_key = SecureRandom.alphanumeric(30)
    self.hashed_api_key = ZenoEncryption.hash_string(@api_key)
  end

  def update_with_use(request)
    self.update({ last_used: Time.now })
  end
end
