class Traders::SessionsController < Devise::SessionsController
    def after_sign_in_path_for(resource)
        trader_dashboard_index_path
    end

    def after_sign_out_path_for(resource)
        destroy_trader_session_path
    end
  end