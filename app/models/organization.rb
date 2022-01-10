class Organization < ApplicationRecord
  # Things this class should do:
  # Send an email to the admin when a user is crud'd
  # Package all media under it

  # This should always be set, but we can't require it because otherwise you get a race condition
  # where the User can't be created without an Organization and an Organization can't be created without
  # a user. We'd rather have dangling organizations than users.
  belongs_to :admin, class_name: :User, required: false

  has_many :users, dependent: :destroy

  before_save :ensure_admin_if_users

private

  # If there are any users we want to make sure at least one is an admin. Throw an error if there are users
  # but there is no admin. If there's no users then just let it go for the reasons described in the comment
  # above.
  def ensure_admin_if_users
    return if users.empty?

    raise Organization::NoAdminError if admin.nil?
  end
end

class Organization::NoAdminError < StandardError; end
