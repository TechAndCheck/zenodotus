class OrganizationsController < ApplicationController
    before_action :authenticate_user!

    def index
        @organization = current_user.organization
    end

    # Only available to super admins
    def list
        authenticate_super_user
    end
end
