class Admin::FactCheckOrganizationsController < ApplicationController
  def index
    @fact_check_organizations = FactCheckOrganization.all.order(:name)
  end
end
