# typed: true

# DO NOT EDIT MANUALLY
# This is an autogenerated file for types exported from the `turbo-rails` gem.
# Please instead update this file by running `bin/tapioca gem turbo-rails`.


class ActionController::Base < ::ActionController::Metal
  include ::ActionDispatch::Routing::PolymorphicRoutes
  include ::ActionController::Head
  include ::AbstractController::Caching::ConfigMethods
  include ::ActionController::BasicImplicitRender
  include ::Devise::Controllers::SignInOut
  include ::Devise::Controllers::StoreLocation
  extend ::AbstractController::Helpers::Resolution

  # source://activesupport/7.2.2.1/lib/active_support/callbacks.rb#70
  def __callbacks; end

  # source://activesupport/7.2.2.1/lib/active_support/callbacks.rb#70
  def __callbacks?; end

  # source://actionpack/7.2.2.1/lib/abstract_controller/helpers.rb#13
  def _helper_methods; end

  # source://actionpack/7.2.2.1/lib/abstract_controller/helpers.rb#13
  def _helper_methods=(_arg0); end

  # source://actionpack/7.2.2.1/lib/abstract_controller/helpers.rb#13
  def _helper_methods?; end

  # source://actionview/7.2.2.1/lib/action_view/layouts.rb#212
  def _layout_conditions; end

  # source://actionview/7.2.2.1/lib/action_view/layouts.rb#212
  def _layout_conditions?; end

  # source://activesupport/7.2.2.1/lib/active_support/callbacks.rb#924
  def _process_action_callbacks; end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/renderers.rb#33
  def _renderers; end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/renderers.rb#33
  def _renderers=(_arg0); end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/renderers.rb#33
  def _renderers?; end

  # source://activesupport/7.2.2.1/lib/active_support/callbacks.rb#912
  def _run_process_action_callbacks(&block); end

  # source://actionpack/7.2.2.1/lib/abstract_controller/caching.rb#44
  def _view_cache_dependencies; end

  # source://actionpack/7.2.2.1/lib/abstract_controller/caching.rb#44
  def _view_cache_dependencies=(_arg0); end

  # source://actionpack/7.2.2.1/lib/abstract_controller/caching.rb#44
  def _view_cache_dependencies?; end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/params_wrapper.rb#185
  def _wrapper_options; end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/params_wrapper.rb#185
  def _wrapper_options=(_arg0); end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/params_wrapper.rb#185
  def _wrapper_options?; end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/flash.rb#38
  def alert; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def allow_forgery_protection; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def allow_forgery_protection=(value); end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def asset_host; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def asset_host=(value); end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def assets_dir; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def assets_dir=(value); end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def csrf_token_storage_strategy; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def csrf_token_storage_strategy=(value); end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def default_asset_host_protocol; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def default_asset_host_protocol=(value); end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def default_static_extension; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def default_static_extension=(value); end

  # source://actionpack/7.2.2.1/lib/action_dispatch/routing/url_for.rb#100
  def default_url_options; end

  # source://actionpack/7.2.2.1/lib/action_dispatch/routing/url_for.rb#100
  def default_url_options=(_arg0); end

  # source://actionpack/7.2.2.1/lib/action_dispatch/routing/url_for.rb#100
  def default_url_options?; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def enable_fragment_cache_logging; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def enable_fragment_cache_logging=(value); end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/etag_with_template_digest.rb#31
  def etag_with_template_digest; end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/etag_with_template_digest.rb#31
  def etag_with_template_digest=(_arg0); end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/etag_with_template_digest.rb#31
  def etag_with_template_digest?; end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/conditional_get.rb#15
  def etaggers; end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/conditional_get.rb#15
  def etaggers=(_arg0); end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/conditional_get.rb#15
  def etaggers?; end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/flash.rb#12
  def flash(*_arg0, **_arg1, &_arg2); end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def forgery_protection_origin_check; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def forgery_protection_origin_check=(value); end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def forgery_protection_strategy; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def forgery_protection_strategy=(value); end

  # source://actionpack/7.2.2.1/lib/abstract_controller/caching/fragments.rb#26
  def fragment_cache_keys; end

  # source://actionpack/7.2.2.1/lib/abstract_controller/caching/fragments.rb#26
  def fragment_cache_keys=(_arg0); end

  # source://actionpack/7.2.2.1/lib/abstract_controller/caching/fragments.rb#26
  def fragment_cache_keys?; end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/helpers.rb#70
  def helpers_path; end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/helpers.rb#70
  def helpers_path=(_arg0); end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/helpers.rb#70
  def helpers_path?; end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/helpers.rb#71
  def include_all_helpers; end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/helpers.rb#71
  def include_all_helpers=(_arg0); end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/helpers.rb#71
  def include_all_helpers?; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def javascripts_dir; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def javascripts_dir=(value); end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def log_warning_on_csrf_failure; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def log_warning_on_csrf_failure=(value); end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def logger; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def logger=(value); end

  # source://responders/3.1.1/lib/action_controller/respond_with.rb#11
  def mimes_for_respond_to; end

  # source://responders/3.1.1/lib/action_controller/respond_with.rb#11
  def mimes_for_respond_to=(_arg0); end

  # source://responders/3.1.1/lib/action_controller/respond_with.rb#11
  def mimes_for_respond_to?; end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/flash.rb#38
  def notice; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def per_form_csrf_tokens; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def per_form_csrf_tokens=(value); end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def perform_caching; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def perform_caching=(value); end

  # source://actionpack/7.2.2.1/lib/abstract_controller/callbacks.rb#36
  def raise_on_missing_callback_actions; end

  # source://actionpack/7.2.2.1/lib/abstract_controller/callbacks.rb#36
  def raise_on_missing_callback_actions=(val); end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/redirecting.rb#17
  def raise_on_open_redirects; end

  # source://actionpack/7.2.2.1/lib/action_controller/metal/redirecting.rb#17
  def raise_on_open_redirects=(val); end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def relative_url_root; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def relative_url_root=(value); end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def request_forgery_protection_token; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def request_forgery_protection_token=(value); end

  # source://activesupport/7.2.2.1/lib/active_support/rescuable.rb#15
  def rescue_handlers; end

  # source://activesupport/7.2.2.1/lib/active_support/rescuable.rb#15
  def rescue_handlers=(_arg0); end

  # source://activesupport/7.2.2.1/lib/active_support/rescuable.rb#15
  def rescue_handlers?; end

  # source://responders/3.1.1/lib/action_controller/respond_with.rb#11
  def responder; end

  # source://responders/3.1.1/lib/action_controller/respond_with.rb#11
  def responder=(_arg0); end

  # source://responders/3.1.1/lib/action_controller/respond_with.rb#11
  def responder?; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
  def stylesheets_dir; end

  # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
  def stylesheets_dir=(value); end

  private

  # source://actionview/7.2.2.1/lib/action_view/layouts.rb#328
  def _layout(lookup_context, formats); end

  def _layout_from_proc; end

  # source://actionpack/7.2.2.1/lib/action_controller/base.rb#324
  def _protected_ivars; end

  class << self
    # source://activesupport/7.2.2.1/lib/active_support/callbacks.rb#70
    def __callbacks; end

    # source://activesupport/7.2.2.1/lib/active_support/callbacks.rb#70
    def __callbacks=(value); end

    # source://activesupport/7.2.2.1/lib/active_support/callbacks.rb#70
    def __callbacks?; end

    # source://actionpack/7.2.2.1/lib/action_controller/form_builder.rb#35
    def _default_form_builder; end

    # source://actionpack/7.2.2.1/lib/action_controller/form_builder.rb#35
    def _default_form_builder=(value); end

    # source://actionpack/7.2.2.1/lib/action_controller/form_builder.rb#35
    def _default_form_builder?; end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/flash.rb#10
    def _flash_types; end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/flash.rb#10
    def _flash_types=(value); end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/flash.rb#10
    def _flash_types?; end

    # source://actionpack/7.2.2.1/lib/abstract_controller/helpers.rb#13
    def _helper_methods; end

    # source://actionpack/7.2.2.1/lib/abstract_controller/helpers.rb#13
    def _helper_methods=(value); end

    # source://actionpack/7.2.2.1/lib/abstract_controller/helpers.rb#13
    def _helper_methods?; end

    # source://actionpack/7.2.2.1/lib/abstract_controller/helpers.rb#17
    def _helpers; end

    # source://actionview/7.2.2.1/lib/action_view/layouts.rb#211
    def _layout; end

    # source://actionview/7.2.2.1/lib/action_view/layouts.rb#211
    def _layout=(value); end

    # source://actionview/7.2.2.1/lib/action_view/layouts.rb#211
    def _layout?; end

    # source://actionview/7.2.2.1/lib/action_view/layouts.rb#212
    def _layout_conditions; end

    # source://actionview/7.2.2.1/lib/action_view/layouts.rb#212
    def _layout_conditions=(value); end

    # source://actionview/7.2.2.1/lib/action_view/layouts.rb#212
    def _layout_conditions?; end

    # source://activesupport/7.2.2.1/lib/active_support/callbacks.rb#916
    def _process_action_callbacks; end

    # source://activesupport/7.2.2.1/lib/active_support/callbacks.rb#920
    def _process_action_callbacks=(value); end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/renderers.rb#33
    def _renderers; end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/renderers.rb#33
    def _renderers=(value); end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/renderers.rb#33
    def _renderers?; end

    # source://actionpack/7.2.2.1/lib/abstract_controller/caching.rb#44
    def _view_cache_dependencies; end

    # source://actionpack/7.2.2.1/lib/abstract_controller/caching.rb#44
    def _view_cache_dependencies=(value); end

    # source://actionpack/7.2.2.1/lib/abstract_controller/caching.rb#44
    def _view_cache_dependencies?; end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/params_wrapper.rb#185
    def _wrapper_options; end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/params_wrapper.rb#185
    def _wrapper_options=(value); end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/params_wrapper.rb#185
    def _wrapper_options?; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def allow_forgery_protection; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def allow_forgery_protection=(value); end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def asset_host; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def asset_host=(value); end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def assets_dir; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def assets_dir=(value); end

    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def csrf_token_storage_strategy; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def csrf_token_storage_strategy=(value); end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def default_asset_host_protocol; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def default_asset_host_protocol=(value); end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def default_static_extension; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def default_static_extension=(value); end

    # source://actionpack/7.2.2.1/lib/action_dispatch/routing/url_for.rb#100
    def default_url_options; end

    # source://actionpack/7.2.2.1/lib/action_dispatch/routing/url_for.rb#100
    def default_url_options=(value); end

    # source://actionpack/7.2.2.1/lib/action_dispatch/routing/url_for.rb#100
    def default_url_options?; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def enable_fragment_cache_logging; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def enable_fragment_cache_logging=(value); end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/etag_with_template_digest.rb#31
    def etag_with_template_digest; end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/etag_with_template_digest.rb#31
    def etag_with_template_digest=(value); end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/etag_with_template_digest.rb#31
    def etag_with_template_digest?; end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/conditional_get.rb#15
    def etaggers; end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/conditional_get.rb#15
    def etaggers=(value); end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/conditional_get.rb#15
    def etaggers?; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def forgery_protection_origin_check; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def forgery_protection_origin_check=(value); end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def forgery_protection_strategy; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def forgery_protection_strategy=(value); end

    # source://actionpack/7.2.2.1/lib/abstract_controller/caching/fragments.rb#26
    def fragment_cache_keys; end

    # source://actionpack/7.2.2.1/lib/abstract_controller/caching/fragments.rb#26
    def fragment_cache_keys=(value); end

    # source://actionpack/7.2.2.1/lib/abstract_controller/caching/fragments.rb#26
    def fragment_cache_keys?; end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/helpers.rb#70
    def helpers_path; end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/helpers.rb#70
    def helpers_path=(value); end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/helpers.rb#70
    def helpers_path?; end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/helpers.rb#71
    def include_all_helpers; end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/helpers.rb#71
    def include_all_helpers=(value); end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/helpers.rb#71
    def include_all_helpers?; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def javascripts_dir; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def javascripts_dir=(value); end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def log_warning_on_csrf_failure; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def log_warning_on_csrf_failure=(value); end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def logger; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def logger=(value); end

    # source://actionpack/7.2.2.1/lib/action_controller/metal.rb#288
    def middleware_stack; end

    # source://responders/3.1.1/lib/action_controller/respond_with.rb#11
    def mimes_for_respond_to; end

    # source://responders/3.1.1/lib/action_controller/respond_with.rb#11
    def mimes_for_respond_to=(value); end

    # source://responders/3.1.1/lib/action_controller/respond_with.rb#11
    def mimes_for_respond_to?; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def per_form_csrf_tokens; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def per_form_csrf_tokens=(value); end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def perform_caching; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def perform_caching=(value); end

    # source://actionpack/7.2.2.1/lib/abstract_controller/callbacks.rb#36
    def raise_on_missing_callback_actions; end

    # source://actionpack/7.2.2.1/lib/abstract_controller/callbacks.rb#36
    def raise_on_missing_callback_actions=(val); end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/redirecting.rb#17
    def raise_on_open_redirects; end

    # source://actionpack/7.2.2.1/lib/action_controller/metal/redirecting.rb#17
    def raise_on_open_redirects=(val); end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def relative_url_root; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def relative_url_root=(value); end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def request_forgery_protection_token; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def request_forgery_protection_token=(value); end

    # source://activesupport/7.2.2.1/lib/active_support/rescuable.rb#15
    def rescue_handlers; end

    # source://activesupport/7.2.2.1/lib/active_support/rescuable.rb#15
    def rescue_handlers=(value); end

    # source://activesupport/7.2.2.1/lib/active_support/rescuable.rb#15
    def rescue_handlers?; end

    # source://responders/3.1.1/lib/action_controller/respond_with.rb#11
    def responder; end

    # source://responders/3.1.1/lib/action_controller/respond_with.rb#11
    def responder=(value); end

    # source://responders/3.1.1/lib/action_controller/respond_with.rb#11
    def responder?; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#115
    def stylesheets_dir; end

    # source://activesupport/7.2.2.1/lib/active_support/configurable.rb#116
    def stylesheets_dir=(value); end

    # source://actionpack/7.2.2.1/lib/action_controller/base.rb#222
    def without_modules(*modules); end
  end
end

# source://turbo-rails//lib/turbo/test_assertions.rb#1
module Turbo
  extend ::ActiveSupport::Autoload

  class << self
    # source://railties/7.2.2.1/lib/rails/engine.rb#412
    def railtie_helpers_paths; end

    # source://railties/7.2.2.1/lib/rails/engine.rb#395
    def railtie_namespace; end

    # source://railties/7.2.2.1/lib/rails/engine.rb#416
    def railtie_routes_url_helpers(include_path_helpers = T.unsafe(nil)); end

    # source://turbo-rails//lib/turbo-rails.rb#9
    def signed_stream_verifier; end

    # source://turbo-rails//lib/turbo-rails.rb#13
    def signed_stream_verifier_key; end

    # Sets the attribute signed_stream_verifier_key
    #
    # @param value the value to set the attribute signed_stream_verifier_key to.
    #
    # source://turbo-rails//lib/turbo-rails.rb#7
    def signed_stream_verifier_key=(_arg0); end

    # source://railties/7.2.2.1/lib/rails/engine.rb#401
    def table_name_prefix; end

    # source://railties/7.2.2.1/lib/rails/engine.rb#408
    def use_relative_model_naming?; end
  end
end

module Turbo::Broadcastable
  extend ::ActiveSupport::Concern

  mixes_in_class_methods ::Turbo::Broadcastable::ClassMethods

  def broadcast_action(action, target: T.unsafe(nil), **rendering); end
  def broadcast_action_later(action:, target: T.unsafe(nil), **rendering); end
  def broadcast_action_later_to(*streamables, action:, target: T.unsafe(nil), **rendering); end
  def broadcast_action_to(*streamables, action:, target: T.unsafe(nil), **rendering); end
  def broadcast_after_to(*streamables, target:, **rendering); end
  def broadcast_append(target: T.unsafe(nil), **rendering); end
  def broadcast_append_later(target: T.unsafe(nil), **rendering); end
  def broadcast_append_later_to(*streamables, target: T.unsafe(nil), **rendering); end
  def broadcast_append_to(*streamables, target: T.unsafe(nil), **rendering); end
  def broadcast_before_to(*streamables, target:, **rendering); end
  def broadcast_prepend(target: T.unsafe(nil), **rendering); end
  def broadcast_prepend_later(target: T.unsafe(nil), **rendering); end
  def broadcast_prepend_later_to(*streamables, target: T.unsafe(nil), **rendering); end
  def broadcast_prepend_to(*streamables, target: T.unsafe(nil), **rendering); end
  def broadcast_remove; end
  def broadcast_remove_to(*streamables, target: T.unsafe(nil)); end
  def broadcast_render(**rendering); end
  def broadcast_render_later(**rendering); end
  def broadcast_render_later_to(*streamables, **rendering); end
  def broadcast_render_to(*streamables, **rendering); end
  def broadcast_replace(**rendering); end
  def broadcast_replace_later(**rendering); end
  def broadcast_replace_later_to(*streamables, **rendering); end
  def broadcast_replace_to(*streamables, **rendering); end
  def broadcast_update(**rendering); end
  def broadcast_update_later(**rendering); end
  def broadcast_update_later_to(*streamables, **rendering); end
  def broadcast_update_to(*streamables, **rendering); end

  private

  def broadcast_rendering_with_defaults(options); end
  def broadcast_target_default; end
end

module Turbo::Broadcastable::ClassMethods
  def broadcast_target_default; end
  def broadcasts(stream = T.unsafe(nil), inserts_by: T.unsafe(nil), target: T.unsafe(nil), **rendering); end
  def broadcasts_to(stream, inserts_by: T.unsafe(nil), target: T.unsafe(nil), **rendering); end
end

module Turbo::DriveHelper
  def turbo_exempts_page_from_cache; end
  def turbo_exempts_page_from_preview; end
  def turbo_page_requires_reload; end
end

# source://turbo-rails//lib/turbo/engine.rb#5
class Turbo::Engine < ::Rails::Engine
  class << self
    # source://activesupport/7.2.2.1/lib/active_support/callbacks.rb#70
    def __callbacks; end
  end
end

# If you don't want to precompile Turbo's assets (eg. because you're using webpack),
# you can do this in an intiailzer:
#
# config.after_initialize do
#   config.assets.precompile -= Turbo::Engine::PRECOMPILE_ASSETS
# end
#
# source://turbo-rails//lib/turbo/engine.rb#29
Turbo::Engine::PRECOMPILE_ASSETS = T.let(T.unsafe(nil), Array)

module Turbo::Frames; end

module Turbo::Frames::FrameRequest
  extend ::ActiveSupport::Concern

  private

  def turbo_frame_request?; end
  def turbo_frame_request_id; end
end

module Turbo::FramesHelper
  def turbo_frame_tag(*ids, src: T.unsafe(nil), target: T.unsafe(nil), **attributes, &block); end
end

module Turbo::IncludesHelper
  def turbo_include_tags; end
end

module Turbo::Native; end

module Turbo::Native::Navigation
  private

  def recede_or_redirect_back_or_to(url, **options); end
  def recede_or_redirect_to(url, **options); end
  def refresh_or_redirect_back_or_to(url, **options); end
  def refresh_or_redirect_to(url, **options); end
  def resume_or_redirect_back_or_to(url, **options); end
  def resume_or_redirect_to(url, **options); end
  def turbo_native_action_or_redirect(url, action, redirect_type, options = T.unsafe(nil)); end
  def turbo_native_app?; end
end

class Turbo::Native::NavigationController < ::ActionController::Base
  def recede; end
  def refresh; end
  def resume; end

  private

  # source://actionview/7.2.2.1/lib/action_view/layouts.rb#328
  def _layout(lookup_context, formats); end

  def _layout_from_proc; end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end

    # source://actionpack/7.2.2.1/lib/action_controller/metal.rb#288
    def middleware_stack; end
  end
end

module Turbo::Streams; end

class Turbo::Streams::ActionBroadcastJob < ::ActiveJob::Base
  def perform(stream, action:, target:, **rendering); end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end

    # source://activesupport/7.2.2.1/lib/active_support/rescuable.rb#15
    def rescue_handlers; end
  end
end

module Turbo::Streams::ActionHelper
  include ::ActionView::Helpers::CaptureHelper
  include ::ActionView::Helpers::OutputSafetyHelper
  include ::ActionView::Helpers::TagHelper

  def turbo_stream_action_tag(action, target: T.unsafe(nil), targets: T.unsafe(nil), template: T.unsafe(nil), **attributes); end

  private

  def convert_to_turbo_stream_dom_id(target, include_selector: T.unsafe(nil)); end
end

class Turbo::Streams::BroadcastJob < ::ActiveJob::Base
  def perform(stream, **rendering); end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end

    # source://activesupport/7.2.2.1/lib/active_support/rescuable.rb#15
    def rescue_handlers; end
  end
end

module Turbo::Streams::Broadcasts
  include ::ActionView::Helpers::CaptureHelper
  include ::ActionView::Helpers::OutputSafetyHelper
  include ::ActionView::Helpers::TagHelper
  include ::Turbo::Streams::ActionHelper

  def broadcast_action_later_to(*streamables, action:, target: T.unsafe(nil), targets: T.unsafe(nil), **rendering); end
  def broadcast_action_to(*streamables, action:, target: T.unsafe(nil), targets: T.unsafe(nil), **rendering); end
  def broadcast_after_later_to(*streamables, **opts); end
  def broadcast_after_to(*streamables, **opts); end
  def broadcast_append_later_to(*streamables, **opts); end
  def broadcast_append_to(*streamables, **opts); end
  def broadcast_before_later_to(*streamables, **opts); end
  def broadcast_before_to(*streamables, **opts); end
  def broadcast_prepend_later_to(*streamables, **opts); end
  def broadcast_prepend_to(*streamables, **opts); end
  def broadcast_remove_to(*streamables, **opts); end
  def broadcast_render_later_to(*streamables, **rendering); end
  def broadcast_render_to(*streamables, **rendering); end
  def broadcast_replace_later_to(*streamables, **opts); end
  def broadcast_replace_to(*streamables, **opts); end
  def broadcast_stream_to(*streamables, content:); end
  def broadcast_update_later_to(*streamables, **opts); end
  def broadcast_update_to(*streamables, **opts); end

  private

  def render_format(format, **rendering); end
end

module Turbo::Streams::StreamName
  def signed_stream_name(streamables); end
  def verified_stream_name(signed_stream_name); end

  private

  def stream_name_from(streamables); end
end

module Turbo::Streams::StreamName::ClassMethods
  def verified_stream_name_from_params; end
end

class Turbo::Streams::TagBuilder
  include ::ActionView::Helpers::CaptureHelper
  include ::ActionView::Helpers::OutputSafetyHelper
  include ::ActionView::Helpers::TagHelper
  include ::Turbo::Streams::ActionHelper

  def initialize(view_context); end

  def action(name, target, content = T.unsafe(nil), allow_inferred_rendering: T.unsafe(nil), **rendering, &block); end
  def action_all(name, targets, content = T.unsafe(nil), allow_inferred_rendering: T.unsafe(nil), **rendering, &block); end
  def after(target, content = T.unsafe(nil), **rendering, &block); end
  def after_all(targets, content = T.unsafe(nil), **rendering, &block); end
  def append(target, content = T.unsafe(nil), **rendering, &block); end
  def append_all(targets, content = T.unsafe(nil), **rendering, &block); end
  def before(target, content = T.unsafe(nil), **rendering, &block); end
  def before_all(targets, content = T.unsafe(nil), **rendering, &block); end
  def prepend(target, content = T.unsafe(nil), **rendering, &block); end
  def prepend_all(targets, content = T.unsafe(nil), **rendering, &block); end
  def remove(target); end
  def remove_all(targets); end
  def replace(target, content = T.unsafe(nil), **rendering, &block); end
  def replace_all(targets, content = T.unsafe(nil), **rendering, &block); end
  def update(target, content = T.unsafe(nil), **rendering, &block); end
  def update_all(targets, content = T.unsafe(nil), **rendering, &block); end

  private

  def render_record(possible_record); end
  def render_template(target, content = T.unsafe(nil), allow_inferred_rendering: T.unsafe(nil), **rendering, &block); end

  class << self
    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

module Turbo::Streams::TurboStreamsTagBuilder
  private

  def turbo_stream; end
end

class Turbo::StreamsChannel < ::ActionCable::Channel::Base
  include ::Turbo::Streams::StreamName::ClassMethods
  extend ::Turbo::Streams::StreamName
  extend ::ActionView::Helpers::CaptureHelper
  extend ::ActionView::Helpers::OutputSafetyHelper
  extend ::ActionView::Helpers::TagHelper
  extend ::Turbo::Streams::ActionHelper
  extend ::Turbo::Streams::Broadcasts

  def subscribed; end

  class << self
    # source://activesupport/7.2.2.1/lib/active_support/callbacks.rb#70
    def __callbacks; end

    # source://comma/4.7.0/lib/comma/object.rb#7
    def comma_formats; end
  end
end

module Turbo::StreamsHelper
  def turbo_stream; end
  def turbo_stream_from(*streamables, **attributes); end
end

# source://turbo-rails//lib/turbo/test_assertions.rb#2
module Turbo::TestAssertions
  extend ::ActiveSupport::Concern

  # source://turbo-rails//lib/turbo/test_assertions.rb#19
  def assert_no_turbo_stream(action:, target: T.unsafe(nil), targets: T.unsafe(nil)); end

  # source://turbo-rails//lib/turbo/test_assertions.rb#10
  def assert_turbo_stream(action:, target: T.unsafe(nil), targets: T.unsafe(nil), status: T.unsafe(nil), &block); end
end
