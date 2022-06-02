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

  # Given a bit of text input, this helper scans it for URLs and, if found, returns them as actual
  # links.
  #
  # Credit for this helper goes to https://gist.github.com/O-I/4dd3a936a09474df97a0
  #
  # @param text String The text you want to scan
  # @returns String The text, with URLs replaced by link tags
  def linkify_urls_in_text(text)
    urls = URI.extract(text, %w(http https)).uniq
    urls.each do |url|
      text.gsub!(url, link_to(url, url, target: "_blank", rel: "noopener noreferrer"))
    end
    text.html_safe
  end
end
