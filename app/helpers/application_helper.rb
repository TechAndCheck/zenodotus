# typed: strict

module ApplicationHelper
  include Pagy::Frontend

  # Given a domain hostname, returns an array with each segment in reverse order: TLD first, then
  # primary domain, then subdomains, then (optionally/rare) an environment.
  # E.g., `"staging.www.example.com"` → `["com","example","www","staging"]`.
  #
  # Explicitly expects to operate on only the hostname, not the protocol, ports, path, etc.
  def hostname_segments(hostname)
    segments = hostname.split(".").reverse

    {                           # E.g., `staging.www.example.com` generates:
      tld:         segments[0], # "com"
      primary:     segments[1], # "example"
      subdomain:   segments[2], # "www"
      environment: segments[3], # "staging" (will usually be `nil`)
    }
  end

  def make_title_tag_content(title_hierarchy = nil, opts = {
    delimeter: "•"
  })

    title_tag_content = ""
    if title_hierarchy.is_a? String
      title_tag_content += title_hierarchy
    elsif title_hierarchy.is_a? Array
      title_tag_content += title_hierarchy.join(" #{opts[:delimeter]} ")
    end

    (title_tag_content.present? ? "#{title_tag_content} #{opts[:delimeter]} " : "") + @site[:title]
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

  # Abbreviates long numbers like 32,348 → 32.3K or 6,325,082 → 6.3M.
  #
  # The use of `try` on the `delete` method is to protect against values that get passed through
  # `number_to_human` intact but don't respond to `delete`, such as nil or booleans.
  #
  # @param number Number The number you want to abbreviated.
  # @returns String The number, abbreviated with its suffix.
  def abbreviate_number(number)
    number_to_human(number, units: {
      thousand: "K",
      million: "M",
      billion: "B",
      trillion: "T" # Look, I'm optimistic about the size of botnets
    }).try(:delete, " ") || "N/A"
  end

  # Generates a list of desired class names (strings) for use in HTML markup.
  #
  # To use, pass a definition hash where the potential class names are the keys and booleans (or
  # operations that resolve to booleans) are the values, e.g.:
  #
  # ```ruby
  # generate_class_list({
  #   "form-element": true,
  #   "required": is_required?,
  #   "disabled": edit_mode == false,
  # })
  # ```
  #
  # Assuming `is_required?` is false and `edit_mode` is false, that would generate an array of:
  # `["form-element", "disabled"]`
  #
  # @param class_definition Hash Definition for which classes should be included.
  # @returns Array The class names whose values resolved to True.
  def generate_class_list(class_definition)
    class_definition.map { |class_name, include_in_list| class_name if include_in_list }
  end

  # Syntacyic sugar for generating an HTML-usable representation of the class list.
  #
  # @param class_definition Hash Definition for which classes should be included.
  # @returns String The class names whose values resolved to True, joined for HTML use.
  def generate_class_list_string(class_definition)
    generate_class_list(class_definition).join(" ")
  end
end
