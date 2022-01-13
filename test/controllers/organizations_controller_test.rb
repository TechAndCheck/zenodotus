require "test_helper"

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "index redirects without authentication" do
    get organizations_url
    assert_redirected_to new_user_session_path
  end

  test "load index if authenticated" do
    sign_in users(:user1)
    get organizations_url
    assert_response :success
  end

  test "can set admin for organization as super admin" do
    # This user is a super admin
    sign_in users(:super_admin)
    put organization_update_admin_url(organizations(:organization1), users(:user3))
    assert_redirected_to controller: :organizations, action: :index
  end

  test "can set admin for organization as organization admin" do
    sign_in users(:user1)

    organization = organizations(:organization1)
    user = users(:user3)

    put organization_update_admin_url(organization, user)
    assert_redirected_to controller: :organizations, action: :index

    organization.reload
    assert organization.admin == user
  end

  test "cannot set admin for organization unless admin" do
    sign_in users(:user3)

    organization = organizations(:organization1)
    user = users(:user3)

    put organization_update_admin_url(organization, user)
    assert_redirected_to "/"

    organization.reload
    assert organization.admin != user
  end

  test "can delete user from organization as super admin" do
    # This user is a super admin
    sign_in users(:super_admin)
    delete organization_delete_user_url(organizations(:organization1), users(:user3))
    assert_redirected_to controller: :organizations, action: :index
  end

  test "can delete user from organization as organization admin" do
    sign_in users(:user1)

    organization = organizations(:organization1)
    user = users(:user3)

    delete organization_delete_user_url(organization, user)
    assert_redirected_to controller: :organizations, action: :index

    organization.reload
    assert_not organization.users.include?(user)
  end

  test "cannot delete user from organization unless admin" do
    sign_in users(:user3)

    organization = organizations(:organization1)
    user = users(:user3)

    delete organization_delete_user_url(organization, user)
    assert_redirected_to "/"

    organization.reload
    assert organization.users.include?(user)
  end
end
