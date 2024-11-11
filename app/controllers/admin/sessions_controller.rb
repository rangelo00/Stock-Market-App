class Admin::SessionsController < Devise::SessionsController
    def after_sign_in(resource)
        admin_dashboard_index_path
    end

    def after_sign_out(resource)
        destroy_admin_session_path
    end
  end