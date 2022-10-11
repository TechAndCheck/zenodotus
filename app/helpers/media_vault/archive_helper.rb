# typed: strict

module MediaVault::ArchiveHelper
  extend T::Sig

  sig { params(number: T.nilable(Integer), noun: String).returns(String) }
  def humanized_community_count(number, noun)
    return "N/A" if number.nil?

    count = number_to_human(number, units: {
      thousand: "K",
      million: "M",
      billion: "B",
      trillion: "T"
    })
    "#{count.delete(" ")} #{noun.pluralize(number)}"
  end
end
