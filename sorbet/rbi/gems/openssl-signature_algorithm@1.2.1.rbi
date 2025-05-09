# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `openssl-signature_algorithm` gem.
# Please instead update this file by running `bin/tapioca gem openssl-signature_algorithm`.


# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/error.rb#4
module OpenSSL::SignatureAlgorithm; end

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/base.rb#12
class OpenSSL::SignatureAlgorithm::Base
  # @return [Boolean]
  #
  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/base.rb#23
  def compatible_verify_key?(verify_key); end

  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/base.rb#27
  def sign(data); end

  # Returns the value of attribute signing_key.
  #
  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/base.rb#13
  def signing_key; end

  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/base.rb#31
  def verify(signature, verification_data); end

  # Returns the value of attribute verify_key.
  #
  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/base.rb#13
  def verify_key; end

  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/base.rb#15
  def verify_key=(key); end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#9
class OpenSSL::SignatureAlgorithm::ECDSA < ::OpenSSL::SignatureAlgorithm::Base
  # @return [ECDSA] a new instance of ECDSA
  #
  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#65
  def initialize(curve: T.unsafe(nil), hash_function: T.unsafe(nil)); end

  # @return [Boolean]
  #
  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#73
  def compatible_verify_key?(key); end

  # Returns the value of attribute curve.
  #
  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#63
  def curve; end

  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#69
  def generate_signing_key; end

  # Returns the value of attribute hash_function.
  #
  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#63
  def hash_function; end

  private

  # Borrowed from jwt rubygem.
  # https://github.com/jwt/ruby-jwt/blob/7a6a3f1dbaff806993156d1dff9c217bb2523ff8/lib/jwt/security_utils.rb#L34-L39
  #
  # Hopefully this will be provided by openssl rubygem in the future.
  #
  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#83
  def formatted_signature(signature); end

  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#100
  def pick_parameters(curve, hash_function); end

  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#96
  def verify_key_length; end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#56
OpenSSL::SignatureAlgorithm::ECDSA::ACCEPTED_PARAMETERS = T.let(T.unsafe(nil), Array)

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#10
OpenSSL::SignatureAlgorithm::ECDSA::BYTE_LENGTH = T.let(T.unsafe(nil), Integer)

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#12
class OpenSSL::SignatureAlgorithm::ECDSA::SigningKey
  # @return [SigningKey] a new instance of SigningKey
  #
  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#13
  def initialize(*args); end

  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#17
  def verify_key; end
end

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#22
class OpenSSL::SignatureAlgorithm::ECDSA::VerifyKey
  # @return [VerifyKey] a new instance of VerifyKey
  #
  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#23
  def initialize(*args); end

  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#35
  def ec_key; end

  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#31
  def serialize; end

  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#51
  def verify(*args); end

  class << self
    # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/ecdsa.rb#27
    def deserialize(pem_string); end
  end
end

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/error.rb#5
class OpenSSL::SignatureAlgorithm::Error < ::StandardError
  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsa.rb#9
class OpenSSL::SignatureAlgorithm::RSA < ::OpenSSL::SignatureAlgorithm::Base
  # @return [RSA] a new instance of RSA
  #
  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsa.rb#39
  def initialize(hash_function: T.unsafe(nil)); end

  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsa.rb#47
  def generate_signing_key(size: T.unsafe(nil)); end

  # Returns the value of attribute hash_function.
  #
  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsa.rb#37
  def hash_function; end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsa.rb#34
OpenSSL::SignatureAlgorithm::RSA::ACCEPTED_HASH_FUNCTIONS = T.let(T.unsafe(nil), Array)

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsa.rb#35
OpenSSL::SignatureAlgorithm::RSA::DEFAULT_KEY_SIZE = T.let(T.unsafe(nil), Integer)

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsa.rb#10
class OpenSSL::SignatureAlgorithm::RSA::SigningKey
  # @return [SigningKey] a new instance of SigningKey
  #
  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsa.rb#11
  def initialize(*args); end

  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsa.rb#15
  def verify_key; end
end

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsa.rb#20
class OpenSSL::SignatureAlgorithm::RSA::VerifyKey
  # @return [VerifyKey] a new instance of VerifyKey
  #
  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsa.rb#25
  def initialize(*args); end

  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsa.rb#29
  def serialize; end

  class << self
    def deserialize(*_arg0); end
  end
end

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsapkcs1.rb#8
class OpenSSL::SignatureAlgorithm::RSAPKCS1 < ::OpenSSL::SignatureAlgorithm::RSA
  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsapss.rb#8
class OpenSSL::SignatureAlgorithm::RSAPSS < ::OpenSSL::SignatureAlgorithm::RSA
  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsapss.rb#23
  def mgf1_hash_function; end

  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsapss.rb#9
  def sign(data); end

  # source://openssl-signature_algorithm//lib/openssl/signature_algorithm/rsapss.rb#13
  def verify(signature, verification_data); end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/base.rb#8
class OpenSSL::SignatureAlgorithm::SignatureVerificationError < ::OpenSSL::SignatureAlgorithm::Error
  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/base.rb#9
class OpenSSL::SignatureAlgorithm::UnsupportedParameterError < ::OpenSSL::SignatureAlgorithm::Error
  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/version.rb#5
OpenSSL::SignatureAlgorithm::VERSION = T.let(T.unsafe(nil), String)

# source://openssl-signature_algorithm//lib/openssl/signature_algorithm/base.rb#10
class OpenSSL::SignatureAlgorithm::VerifyKeyError < ::OpenSSL::SignatureAlgorithm::Error
  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end
