class Admin::SessionsController < Devise::SessionsController
    def after_sign_in_path_for(resource)
        admin_dashboard_index_path
    end

    def after_sign_out_path_for(resource)
        destroy_admin_session_path
    end
  end