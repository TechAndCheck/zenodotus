class ApiKey < ApplicationRecord
  belongs_to :user, required: true
  attr_reader :api_key

  before_create :create_api_key

  def create_api_key
    @api_key = SecureRandom.alphanumeric(30)
    self.hashed_api_key = Digest::SHA512.hexdigest @api_key
  end
end
