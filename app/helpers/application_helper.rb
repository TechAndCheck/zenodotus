# typed: strict

module ApplicationHelper
  include Pagy::Frontend

  def site_is_fact_check_insights?(site)
    site == SiteDefinitions::FACT_CHECK_INSIGHTS
  end

  def site_is_media_vault?(site)
    site == SiteDefinitions::MEDIA_VAULT
  end

  def make_title_tag_content(title_hierarchy = nil, opts = {
    delimeter: "•"
  })
    title_tag_content = ""
    if title_hierarchy.is_a? String
      title_tag_content += title_hierarchy
    elsif title_hierarchy.is_a? Array
      title_tag_content += title_hierarchy.compact.join(" #{opts[:delimeter]} ")
    end

    (title_tag_content.present? ? "#{title_tag_content} #{opts[:delimeter]} " : "") + @site[:title]
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

  # Generate an SVG from our SVG library.
  #
  # Example: `use_svg("sample-icon", title: "Descriptive title")`
  # Output:
  # ```
  # <svg>
  #   <title>Descriptive title</title>
  #   <use xlink:href="#svg-sample-icon">
  # </svg>
  # ```
  #
  # Note that `id` is a required positional parameter, but all remaining parameters are keywords
  # and optional.
  #
  # @param id String The ID of the desired SVG icon from the `_svg_library.html.erb` template.
  # @param svg_attrs Hash Optional hash of parameters for the SVG element.
  # @param title String Optional title content for accessibility.
  # @param title_attrs Hash Optional hash of parameters for the title element.
  # @returns String
  def use_svg(id, svg_attrs: {}, title: nil, title_attrs: {})
    title_tag = title.present? ? tag.title(title, **title_attrs) : nil
    use_tag = tag.use "xlink:href": "#svg-#{id}"
    tag.svg "#{title_tag}#{use_tag}".html_safe, **svg_attrs
  end

  # Provided a Twitter username, returns an icon-prefixed link to the Twitter bio.
  #
  # @param username String
  # @returns String Icon-prefixed link to the Twitter account
  def twitter_link_to(username)
    icon = use_svg "twitter", svg_attrs: { class: "icon" }
    label = tag.span "@#{username}"
    link_to "#{icon}#{label}".html_safe, "https://twitter.com/#{username}", class: "icon-prefixed"
  end

  # Provided an email address, returns an icon-prefixed mailto link.
  #
  # @param email String
  # @returns String Icon-prefixed mailto link
  def email_link_to(email)
    icon = use_svg "email", svg_attrs: { class: "icon" }
    label = tag.span email
    mail_to email, "#{icon}#{label}".html_safe, class: "icon-prefixed"
  end
end
