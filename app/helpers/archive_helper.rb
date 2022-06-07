# typed: strict
module ArchiveHelper
  def humanized_community_count(number, noun)
    count = number_to_human(number, units: {
      thousand: "K",
      million: "M",
      billion: "B",
      trillion: "T"
    })
    "#{count.delete(" ")} #{noun.pluralize(number)}"
  end
end
