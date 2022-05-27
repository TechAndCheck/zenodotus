# typed: strict
module ApplicationHelper
  include Pagy::Frontend

  def make_title_tag_content(title_hierarchy = nil, opts = {
    delimeter: "•"
  })

    title_tag_content = ""
    if title_hierarchy.is_a? String
      title_tag_content += title_hierarchy
    elsif title_hierarchy.is_a? Array
      title_tag_content += title_hierarchy.join(" #{opts[:delimeter]} ")
    end

    (title_tag_content.present? ? "#{title_tag_content} #{opts[:delimeter]} " : "") + "Zenodotus"
  end

  def color_for_flash_type(flash_type)
    flash_type = flash_type.to_sym

    flash_color_map = {
      alert: "yellow",
      notice: "blue",
      info: "blue",
      success: "green",
      error: "red",
    }

    flash_color_map.has_key?(flash_type) ? flash_color_map[flash_type] : "blue"
  end

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
