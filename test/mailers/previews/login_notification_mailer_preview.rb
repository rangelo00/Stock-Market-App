# Preview all emails at http://localhost:3000/rails/mailers/login_notification_mailer
class LoginNotificationMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/login_notification_mailer/notify_login
  def notify_login
    LoginNotificationMailer.notify_login
  end
end
