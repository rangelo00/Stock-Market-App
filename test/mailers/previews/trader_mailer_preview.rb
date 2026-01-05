# Preview all emails at http://localhost:3000/rails/mailers/trader_mailer
class TraderMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/trader_mailer/account_approved
  def account_approved
    TraderMailer.account_approved
  end

  # Preview this email at http://localhost:3000/rails/mailers/trader_mailer/account_rejected
  def account_rejected
    TraderMailer.account_rejected
  end
end
