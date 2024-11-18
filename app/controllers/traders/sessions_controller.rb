# app/controllers/traders/sessions_controller.rb
class Traders::SessionsController < Devise::SessionsController
    def create
      super
      if current_trader
        @email = LoginNotificationMailer.notify_login(current_trader, request).deliver_now
        
        preview_path = Rails.root.join('public', 'email_preview.html')
        File.write(preview_path, @email.html_part.body.to_s)
        
        session[:show_email_preview] = true
      end
    end
  
    def after_sign_in_path_for(resource)
      if session[:show_email_preview]
        session[:show_email_preview] = nil
        '/email_preview.html'
      else
        traders_dashboard_index_path  # Make sure this matches your route
      end
    end
  
    def after_sign_out_path_for(resource)
      new_trader_session_path
    end
  end