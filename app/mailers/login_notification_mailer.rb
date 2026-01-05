# app/mailers/login_notification_mailer.rb
class LoginNotificationMailer < ApplicationMailer
  def notify_login(user, request = nil)
    @user = user
    @user_type = if user.class.name == "Traders"
      "Trader"
    else
      "Admin"
    end  # This will return "Admin" or "Trader"
    @login_time = Time.current
    @ip_address = request&.remote_ip || 'Unknown'
    @user_agent = request&.user_agent || 'Unknown'
    @redirect_path = determine_dashboard_path(@user_type)

    mail(
      to: user.email,
      subject: "New #{@user_type} Login Detected"
    )
  end

  private

  def determine_dashboard_path(user_type)
    case user_type.downcase
    when 'trader'
      '/traders/dashboard'
    when 'admin'
      '/admin/dashboard'
    else
      '/' # Default fallback route
    end
  end
end