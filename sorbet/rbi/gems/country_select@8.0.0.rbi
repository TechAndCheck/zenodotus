# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `country_select` gem.
# Please instead update this file by running `bin/tapioca gem country_select`.


# source://country_select//lib/country_select/country_select_helper.rb#1
module ActionView
  class << self
    # source://actionview/7.2.2.1/lib/action_view/deprecator.rb#4
    def deprecator; end

    # source://actionview/7.2.2.1/lib/action_view.rb#93
    def eager_load!; end

    # source://actionview/7.2.2.1/lib/action_view/gem_version.rb#5
    def gem_version; end

    # source://actionview/7.2.2.1/lib/action_view/version.rb#7
    def version; end
  end
end

# source://country_select//lib/country_select/country_select_helper.rb#2
module ActionView::Helpers
  include ::ActionView::Helpers::SanitizeHelper
  include ::ActionView::Helpers::TextHelper
  include ::ActionView::Helpers::UrlHelper
  include ::ActionView::Helpers::SanitizeHelper
  include ::ActionView::Helpers::TextHelper
  include ::ActionView::Helpers::FormTagHelper
  include ::ActionView::Helpers::FormHelper
  include ::ActionView::Helpers::TranslationHelper

  mixes_in_class_methods ::ActionView::Helpers::UrlHelper::ClassMethods
  mixes_in_class_methods ::ActionView::Helpers::SanitizeHelper::ClassMethods

  class << self
    # source://actionview/7.2.2.1/lib/action_view/helpers.rb#35
    def eager_load!; end
  end
end

# source://country_select//lib/country_select/country_select_helper.rb#3
class ActionView::Helpers::FormBuilder
  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1717
  def initialize(object_name, object, template, options); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2649
  def button(value = T.unsafe(nil), options = T.unsafe(nil), &block); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2474
  def check_box(method, options = T.unsafe(nil), checked_value = T.unsafe(nil), unchecked_value = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#908
  def collection_check_boxes(method, collection, value_method, text_method, options = T.unsafe(nil), html_options = T.unsafe(nil), &block); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#920
  def collection_radio_buttons(method, collection, value_method, text_method, options = T.unsafe(nil), html_options = T.unsafe(nil), &block); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#860
  def collection_select(method, collection, value_method, text_method, options = T.unsafe(nil), html_options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2042
  def color_field(method, options = T.unsafe(nil)); end

  # source://country_select//lib/country_select/country_select_helper.rb#4
  def country_select(method, priority_or_options = T.unsafe(nil), options = T.unsafe(nil), html_options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2070
  def date_field(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/date_helper.rb#1237
  def date_select(method, options = T.unsafe(nil), html_options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2084
  def datetime_field(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2091
  def datetime_local_field(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/date_helper.rb#1261
  def datetime_select(method, options = T.unsafe(nil), html_options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2119
  def email_field(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2670
  def emitted_hidden_id?; end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1682
  def field_helpers; end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1682
  def field_helpers=(_arg0); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1682
  def field_helpers?; end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1774
  def field_id(method, *suffixes, namespace: T.unsafe(nil), index: T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1794
  def field_name(method, *methods, multiple: T.unsafe(nil), index: T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2328
  def fields(scope = T.unsafe(nil), model: T.unsafe(nil), **options, &block); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2290
  def fields_for(record_name, record_object = T.unsafe(nil), fields_options = T.unsafe(nil), &block); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2557
  def file_field(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#872
  def grouped_collection_select(method, collection, group_method, group_label_method, option_key_method, option_value_method, options = T.unsafe(nil), html_options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2518
  def hidden_field(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1754
  def id; end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1694
  def index; end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2405
  def label(method, text = T.unsafe(nil), options = T.unsafe(nil), &block); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2098
  def month_field(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1694
  def multipart; end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1697
  def multipart=(multipart); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1694
  def multipart?; end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2126
  def number_field(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1692
  def object; end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1692
  def object=(_arg0); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1692
  def object_name; end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1692
  def object_name=(_arg0); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1692
  def options; end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1692
  def options=(_arg0); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2028
  def password_field(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2063
  def phone_field(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2496
  def radio_button(method, tag_value, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2133
  def range_field(method, options = T.unsafe(nil)); end

  def rich_text_area(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2049
  def search_field(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#848
  def select(method, choices = T.unsafe(nil), options = T.unsafe(nil), html_options = T.unsafe(nil), &block); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2589
  def submit(value = T.unsafe(nil), options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2056
  def telephone_field(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2035
  def text_area(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2021
  def text_field(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2077
  def time_field(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/date_helper.rb#1249
  def time_select(method, options = T.unsafe(nil), html_options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#884
  def time_zone_select(method, priority_zones = T.unsafe(nil), options = T.unsafe(nil), html_options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1713
  def to_model; end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1709
  def to_partial_path; end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2112
  def url_field(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2105
  def week_field(method, options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#896
  def weekday_select(method, options = T.unsafe(nil), html_options = T.unsafe(nil)); end

  private

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2755
  def convert_to_legacy_options(options); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2737
  def fields_for_nested_model(name, object, fields_options, block); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2708
  def fields_for_with_nested_attributes(association_name, association, options, block); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2704
  def nested_attributes_association?(association_name); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2750
  def nested_child_index(name); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2675
  def objectify_options(options); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#2681
  def submit_default_value; end

  class << self
    # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1705
    def _to_partial_path; end

    # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1682
    def field_helpers; end

    # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1682
    def field_helpers=(value); end

    # source://actionview/7.2.2.1/lib/action_view/helpers/form_helper.rb#1682
    def field_helpers?; end
  end
end

# source://country_select//lib/country_select/country_select_helper.rb#21
module ActionView::Helpers::FormOptionsHelper
  include ::ActionView::Helpers::CaptureHelper
  include ::ActionView::Helpers::OutputSafetyHelper
  include ::ActionView::Helpers::TagHelper

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#782
  def collection_check_boxes(object, method, collection, value_method, text_method, options = T.unsafe(nil), html_options = T.unsafe(nil), &block); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#698
  def collection_radio_buttons(object, method, collection, value_method, text_method, options = T.unsafe(nil), html_options = T.unsafe(nil), &block); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#199
  def collection_select(object, method, collection, value_method, text_method, options = T.unsafe(nil), html_options = T.unsafe(nil)); end

  # source://country_select//lib/country_select/country_select_helper.rb#22
  def country_select(object, method, options = T.unsafe(nil), html_options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#258
  def grouped_collection_select(object, method, collection, group_method, group_label_method, option_key_method, option_value_method, options = T.unsafe(nil), html_options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#534
  def grouped_options_for_select(grouped_options, selected_key = T.unsafe(nil), options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#462
  def option_groups_from_collection_for_select(collection, group_method, group_label_method, option_key_method, option_value_method, selected_key = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#358
  def options_for_select(container, selected = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#401
  def options_from_collection_for_select(collection, value_method, text_method, selected = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#159
  def select(object, method, choices = T.unsafe(nil), options = T.unsafe(nil), html_options = T.unsafe(nil), &block); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#579
  def time_zone_options_for_select(selected = T.unsafe(nil), priority_zones = T.unsafe(nil), model = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#292
  def time_zone_select(object, method, priority_zones = T.unsafe(nil), options = T.unsafe(nil), html_options = T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#611
  def weekday_options_for_select(selected = T.unsafe(nil), index_as_value: T.unsafe(nil), day_format: T.unsafe(nil), beginning_of_week: T.unsafe(nil)); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#298
  def weekday_select(object, method, options = T.unsafe(nil), html_options = T.unsafe(nil), &block); end

  private

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#809
  def extract_selected_and_disabled(selected); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#820
  def extract_values_from_collection(collection, value_method, selected); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#787
  def option_html_attributes(element); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#795
  def option_text_and_value(option); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#805
  def option_value_selected?(value, selected); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#834
  def prompt_text(prompt); end

  # source://actionview/7.2.2.1/lib/action_view/helpers/form_options_helper.rb#830
  def value_for_collection(item, value); end
end

# source://country_select//lib/country_select/country_select_helper.rb#27
module ActionView::Helpers::Tags; end

# source://country_select//lib/country_select/country_select_helper.rb#28
class ActionView::Helpers::Tags::CountrySelect < ::ActionView::Helpers::Tags::Base
  include ::CountrySelect::TagHelper

  # @return [CountrySelect] a new instance of CountrySelect
  #
  # source://country_select//lib/country_select/country_select_helper.rb#31
  def initialize(object_name, method_name, template_object, options, html_options); end

  # source://country_select//lib/country_select/country_select_helper.rb#37
  def render; end
end

# source://country_select//lib/country_select/version.rb#1
module CountrySelect; end

# source://country_select//lib/country_select/tag_helper.rb#2
class CountrySelect::CountryNotFoundError < ::StandardError; end

# source://country_select//lib/country_select/defaults.rb#2
CountrySelect::DEFAULTS = T.let(T.unsafe(nil), Hash)

# source://country_select//lib/country_select/formats.rb#2
CountrySelect::FORMATS = T.let(T.unsafe(nil), Hash)

# source://country_select//lib/country_select/tag_helper.rb#3
module CountrySelect::TagHelper
  # source://country_select//lib/country_select/tag_helper.rb#4
  def country_option_tags; end

  private

  # source://country_select//lib/country_select/tag_helper.rb#65
  def all_country_codes; end

  # source://country_select//lib/country_select/tag_helper.rb#61
  def country_options; end

  # source://country_select//lib/country_select/tag_helper.rb#77
  def country_options_for(country_codes, sorted = T.unsafe(nil)); end

  # source://country_select//lib/country_select/tag_helper.rb#53
  def except_country_codes; end

  # source://country_select//lib/country_select/tag_helper.rb#57
  def format; end

  # source://country_select//lib/country_select/tag_helper.rb#109
  def html_safe_newline; end

  # source://country_select//lib/country_select/tag_helper.rb#37
  def locale; end

  # source://country_select//lib/country_select/tag_helper.rb#49
  def only_country_codes; end

  # source://country_select//lib/country_select/tag_helper.rb#41
  def priority_countries; end

  # source://country_select//lib/country_select/tag_helper.rb#45
  def priority_countries_divider; end
end

# source://country_select//lib/country_select/version.rb#2
CountrySelect::VERSION = T.let(T.unsafe(nil), String)
