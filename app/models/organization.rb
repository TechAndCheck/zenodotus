class Organization < ApplicationRecord
    # Things this class should do:
    # Send an email to the admin when a user is crud'd
    # Package all media under it
    belongs_to :admin, class_name: :User, required: true
end
