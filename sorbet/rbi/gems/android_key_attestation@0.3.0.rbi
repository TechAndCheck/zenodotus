# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `android_key_attestation` gem.
# Please instead update this file by running `bin/tapioca gem android_key_attestation`.


# source://android_key_attestation//lib/android_key_attestation.rb#3
module AndroidKeyAttestation; end

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#4
class AndroidKeyAttestation::AuthorizationList
  # @return [AuthorizationList] a new instance of AuthorizationList
  #
  # source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#59
  def initialize(sequence); end

  # source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#68
  def all_applications; end

  # source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#72
  def creation_date; end

  # source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#81
  def find_by_tag(tag); end

  # source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#76
  def origin; end

  # source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#63
  def purpose; end

  private

  # source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#98
  def find_boolean(tag); end

  # source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#94
  def find_optional_integer(tag); end

  # source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#89
  def find_optional_integer_set(tag); end

  # source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#102
  def find_time_milliseconds(tag); end

  # Returns the value of attribute sequence.
  #
  # source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#87
  def sequence; end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#14
AndroidKeyAttestation::AuthorizationList::ACTIVE_DATE_TIME_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#7
AndroidKeyAttestation::AuthorizationList::ALGORITHM_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#20
AndroidKeyAttestation::AuthorizationList::ALLOW_WHILE_ON_BODY_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#24
AndroidKeyAttestation::AuthorizationList::ALL_APPLICATIONS_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#25
AndroidKeyAttestation::AuthorizationList::APPLICATION_ID_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#31
AndroidKeyAttestation::AuthorizationList::ATTESTATION_APPLICATION_ID_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#32
AndroidKeyAttestation::AuthorizationList::ATTESTATION_ID_BRAND_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#33
AndroidKeyAttestation::AuthorizationList::ATTESTATION_ID_DEVICE_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#36
AndroidKeyAttestation::AuthorizationList::ATTESTATION_ID_IMEI_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#38
AndroidKeyAttestation::AuthorizationList::ATTESTATION_ID_MANUFACTURER_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#37
AndroidKeyAttestation::AuthorizationList::ATTESTATION_ID_MEID_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#39
AndroidKeyAttestation::AuthorizationList::ATTESTATION_ID_MODEL_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#34
AndroidKeyAttestation::AuthorizationList::ATTESTATION_ID_PRODUCT_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#35
AndroidKeyAttestation::AuthorizationList::ATTESTATION_ID_SERIAL_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#19
AndroidKeyAttestation::AuthorizationList::AUTH_TIMEOUT_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#41
AndroidKeyAttestation::AuthorizationList::BOOT_PATCH_LEVEL_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#26
AndroidKeyAttestation::AuthorizationList::CREATION_DATE_TIME_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#9
AndroidKeyAttestation::AuthorizationList::DIGEST_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#11
AndroidKeyAttestation::AuthorizationList::EC_CURVE_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#8
AndroidKeyAttestation::AuthorizationList::KEY_SIZE_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#17
AndroidKeyAttestation::AuthorizationList::NO_AUTH_REQUIRED_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#15
AndroidKeyAttestation::AuthorizationList::ORIGINATION_EXPIRE_DATE_TIME_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#52
AndroidKeyAttestation::AuthorizationList::ORIGIN_ENUM = T.let(T.unsafe(nil), Hash)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#27
AndroidKeyAttestation::AuthorizationList::ORIGIN_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#30
AndroidKeyAttestation::AuthorizationList::OS_PATCH_LEVEL_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#29
AndroidKeyAttestation::AuthorizationList::OS_VERSION_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#10
AndroidKeyAttestation::AuthorizationList::PADDING_TAG = T.let(T.unsafe(nil), Integer)

# https://source.android.com/security/keystore/tags
#
# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#44
AndroidKeyAttestation::AuthorizationList::PURPOSE_ENUM = T.let(T.unsafe(nil), Hash)

# https://source.android.com/security/keystore/attestation#attestation-extension
#
# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#6
AndroidKeyAttestation::AuthorizationList::PURPOSE_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#13
AndroidKeyAttestation::AuthorizationList::ROLLBACK_RESISTANCE_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#28
AndroidKeyAttestation::AuthorizationList::ROOT_OF_TRUST_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#12
AndroidKeyAttestation::AuthorizationList::RSA_PUBLIC_EXPONENT_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#22
AndroidKeyAttestation::AuthorizationList::TRUSTED_CONFIRMATION_REQUIRED_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#21
AndroidKeyAttestation::AuthorizationList::TRUSTED_USER_PRESENCE_REQUIRED_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#23
AndroidKeyAttestation::AuthorizationList::UNLOCK_DEVICE_REQUIRED_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#16
AndroidKeyAttestation::AuthorizationList::USAGE_EXPIRE_DATE_TIME_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#18
AndroidKeyAttestation::AuthorizationList::USER_AUTH_TYPE_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/authorization_list.rb#40
AndroidKeyAttestation::AuthorizationList::VENDOR_PATCH_LEVEL_TAG = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation.rb#7
class AndroidKeyAttestation::CertificateVerificationError < ::AndroidKeyAttestation::Error
  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://android_key_attestation//lib/android_key_attestation.rb#6
class AndroidKeyAttestation::ChallengeMismatchError < ::AndroidKeyAttestation::Error
  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://android_key_attestation//lib/android_key_attestation.rb#4
class AndroidKeyAttestation::Error < ::StandardError
  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://android_key_attestation//lib/android_key_attestation.rb#5
class AndroidKeyAttestation::ExtensionMissingError < ::AndroidKeyAttestation::Error
  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://android_key_attestation//lib/android_key_attestation/fixed_length_secure_compare.rb#6
module AndroidKeyAttestation::FixedLengthSecureCompare; end

# source://android_key_attestation//lib/android_key_attestation.rb#9
AndroidKeyAttestation::GEM_ROOT = T.let(T.unsafe(nil), String)

# source://android_key_attestation//lib/android_key_attestation/key_description.rb#6
class AndroidKeyAttestation::KeyDescription
  # @return [KeyDescription] a new instance of KeyDescription
  #
  # source://android_key_attestation//lib/android_key_attestation/key_description.rb#23
  def initialize(sequence); end

  # source://android_key_attestation//lib/android_key_attestation/key_description.rb#43
  def attestation_challenge; end

  # source://android_key_attestation//lib/android_key_attestation/key_description.rb#31
  def attestation_security_level; end

  # source://android_key_attestation//lib/android_key_attestation/key_description.rb#27
  def attestation_version; end

  # source://android_key_attestation//lib/android_key_attestation/key_description.rb#39
  def keymaster_security_level; end

  # source://android_key_attestation//lib/android_key_attestation/key_description.rb#35
  def keymaster_version; end

  # source://android_key_attestation//lib/android_key_attestation/key_description.rb#55
  def software_enforced; end

  # source://android_key_attestation//lib/android_key_attestation/key_description.rb#51
  def tee_enforced; end

  # source://android_key_attestation//lib/android_key_attestation/key_description.rb#47
  def unique_id; end

  private

  # Returns the value of attribute sequence.
  #
  # source://android_key_attestation//lib/android_key_attestation/key_description.rb#61
  def sequence; end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://android_key_attestation//lib/android_key_attestation/key_description.rb#12
AndroidKeyAttestation::KeyDescription::ATTESTATION_CHALLENGE_INDEX = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/key_description.rb#9
AndroidKeyAttestation::KeyDescription::ATTESTATION_SECURITY_LEVEL_INDEX = T.let(T.unsafe(nil), Integer)

# https://developer.android.com/training/articles/security-key-attestation#certificate_schema
#
# source://android_key_attestation//lib/android_key_attestation/key_description.rb#8
AndroidKeyAttestation::KeyDescription::ATTESTATION_VERSION_INDEX = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/key_description.rb#11
AndroidKeyAttestation::KeyDescription::KEYMASTER_SECURITY_LEVEL_INDEX = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/key_description.rb#10
AndroidKeyAttestation::KeyDescription::KEYMASTER_VERSION_INDEX = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/key_description.rb#17
AndroidKeyAttestation::KeyDescription::SECURITY_LEVEL_ENUM = T.let(T.unsafe(nil), Hash)

# source://android_key_attestation//lib/android_key_attestation/key_description.rb#14
AndroidKeyAttestation::KeyDescription::SOFTWARE_ENFORCED_INDEX = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/key_description.rb#15
AndroidKeyAttestation::KeyDescription::TEE_ENFORCED_INDEX = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/key_description.rb#13
AndroidKeyAttestation::KeyDescription::UNIQUE_ID_INDEX = T.let(T.unsafe(nil), Integer)

# source://android_key_attestation//lib/android_key_attestation/statement.rb#9
class AndroidKeyAttestation::Statement
  extend ::Forwardable

  # @return [Statement] a new instance of Statement
  #
  # source://android_key_attestation//lib/android_key_attestation/statement.rb#22
  def initialize(*certificates); end

  # source://android_key_attestation//lib/android_key_attestation/statement.rb#26
  def attestation_certificate; end

  # source://forwardable/1.3.3/forwardable.rb#231
  def attestation_security_level(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def attestation_version(*args, **_arg1, &block); end

  # source://android_key_attestation//lib/android_key_attestation/statement.rb#46
  def key_description; end

  # source://forwardable/1.3.3/forwardable.rb#231
  def keymaster_security_level(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def keymaster_version(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def software_enforced(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def tee_enforced(*args, **_arg1, &block); end

  # source://forwardable/1.3.3/forwardable.rb#231
  def unique_id(*args, **_arg1, &block); end

  # source://android_key_attestation//lib/android_key_attestation/statement.rb#37
  def verify_certificate_chain(root_certificates: T.unsafe(nil), time: T.unsafe(nil)); end

  # source://android_key_attestation//lib/android_key_attestation/statement.rb#30
  def verify_challenge(challenge); end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

# source://android_key_attestation//lib/android_key_attestation/statement.rb#10
AndroidKeyAttestation::Statement::EXTENSION_DATA_OID = T.let(T.unsafe(nil), String)

# source://android_key_attestation//lib/android_key_attestation/statement.rb#11
AndroidKeyAttestation::Statement::GOOGLE_ROOT_CERTIFICATES = T.let(T.unsafe(nil), Array)

# source://android_key_attestation//lib/android_key_attestation/version.rb#4
AndroidKeyAttestation::VERSION = T.let(T.unsafe(nil), String)
