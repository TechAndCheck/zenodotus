require_relative "20220106154007_create_organizations"
require_relative "20220107142219_add_organization_to_users"
require_relative "20210803182641_add_admin_aproved_to_users"

class RemoveOrganizations < ActiveRecord::Migration[7.0]
  def change
    revert AddAdminAprovedToUsers
    revert AddOrganizationToUsers
    revert CreateOrganizations
  end
end
