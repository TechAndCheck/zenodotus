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

    return (title_tag_content.present? ? "#{title_tag_content} #{opts[:delimeter]} " : "") + "Zenodotus"
  end
end
