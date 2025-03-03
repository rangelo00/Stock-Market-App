class Traders::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    
    if resource && resource.approved?
      sign_in(resource_name, resource)
      
      # Send login notification if needed
      @email = LoginNotificationMailer.notify_login(resource, request).deliver_now
      
      preview_path = Rails.root.join('public', 'email_preview.html')
      File.write(preview_path, @email.html_part.body.to_s)
      
      session[:show_email_preview] = true
      
      redirect_to traders_dashboard_path
    else
      flash[:alert] = "Your account is pending approval or has been rejected."
      redirect_to new_trader_session_path
    end
  end

  def after_sign_in_path_for(resource)
    if session[:show_email_preview]
      session[:show_email_preview] = nil
      '/email_preview.html'
    else
      traders_dashboard_path
    end
  end

  def after_sign_out_path_for(resource)
    new_trader_session_path
  end

  protected

  def auth_options
    { scope: :trader }
  end
end