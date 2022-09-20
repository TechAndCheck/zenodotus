Rolify.configure do |config|
  # By default ORM adapter is ActiveRecord. uncomment to use mongoid
  # config.use_mongoid

  # Dynamic shortcuts for User class (user.is_admin? like methods). Default is: false
  #
  # Enabled because these are convenient methods, and according to the Rolify documentation they
  # are generated at boot time (and when `add_role` is run), so shouldn't hurt performance.
  config.use_dynamic_shortcuts

  # Configuration to remove roles from database once the last resource is removed. Default is: true
  #
  # Toggled to false because we have well-defined user roles that we don't want removed, even if
  # the last user using them is deleted.
  config.remove_role_if_empty = false
end
