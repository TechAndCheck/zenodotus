class Organization < ApplicationRecord
  # Things this class should do:
  # Send an email to the admin when a user is crud'd
  # Package all media under it

  # This should always be set, but we can't require it because otherwise you get a race condition
  # where the User can't be created without an Organization and an Organization can't be created without
  # a user. We'd rather have dangling organizations than users.
  belongs_to :admin, class_name: :User, required: false

  has_many :users, dependent: :destroy
end
