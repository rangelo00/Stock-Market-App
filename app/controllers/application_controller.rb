class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(resource)
    case resource
    when Admin
      admin_dashboard_path
    when Trader
      traders_dashboard_path
    else
      root_path
    end
  end
end