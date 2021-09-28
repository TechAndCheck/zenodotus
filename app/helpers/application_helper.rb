# typed: strict
module ApplicationHelper

  # A helper function that makes Schema.org objects postgres-friendly
  def self.clean_schema_org_hash(h)
    h.transform_keys do |key|
      if key == "@type"
        "_type"
      elsif key.downcase != key
        self.convert_from_camel_case(key)
      else
        key
      end
    end
  end

  # A helper function that returns an underscored version of a camelCase string
  def self.convert_from_camel_case(str)
    underscored_str = ""
    str.each_char { |ch| underscored_str << (ch.upcase == ch ? "_" + ch.downcase : ch ) }
    underscored_str
  end
end
