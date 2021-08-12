# typed: true

class ZenoEncryption
  extend T::Sig
  extend T::Helpers

  # Hash a string using Sha512 (and eventually a salt)
  # @param string String the string to hash
  # @returns String the Sha512 hash value of `string`
  sig { params(string: String).returns(String) }
  def self.hash_string(string)
    Digest::SHA512.hexdigest(string)
  end
end
