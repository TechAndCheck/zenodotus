# typed: true

class ZenoEncryption
  extend T::Sig
  extend T::Helpers

  # Hash a string using Sha512 (and eventually a salt)
  # @param string String the string to hash
  # @returns String the Sha512 hash value of `string`
  sig { params(string: String).returns(String) }
  def self.hash_string(string)
    # Tack on a salt for better encryption and to prevent rainbow attacks
    string = Figaro.env.KEY_ENCRYPTION_SALT + string
    Digest::SHA512.hexdigest(string)
  end
end
