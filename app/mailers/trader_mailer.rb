class TraderMailer < ApplicationMailer
  def account_approved(trader)
    Rails.logger.info "=== TraderMailer#account_approved ==="
    Rails.logger.info "Sending to: #{trader.email}"
    
    @trader = trader
    @login_url = new_trader_session_url
    
    mail(
      to: @trader.email,
      from: ENV['GMAIL_USERNAME'],  # Add explicit from address
      subject: 'Approved ka na!'
    ) do |format|
      format.html { render 'account_approved' }
    end
  rescue => e
    Rails.logger.error "Approval email failed: #{e.message}"
    raise e
  end

  def account_rejected(pending_trader)
    Rails.logger.info "=== TraderMailer#account_rejected ==="
    Rails.logger.info "Sending to: #{pending_trader.email}"
    
    @email = pending_trader.email
    mail(
      to: @email,
      from: ENV['GMAIL_USERNAME'],  # Add explicit from address
      subject: 'Dukha ka pa. Come back later.'
    ) do |format|
      format.html { render 'account_rejected' }
    end
  rescue => e
    Rails.logger.error "Rejection email failed: #{e.message}"
    raise e
  end

  def account_deleted(trader)
    Rails.logger.info "=== TraderMailer#account_deleted ==="
    Rails.logger.info "Sending to: #{trader.email}"
    
    @email = trader.email
    mail(
      to: @email,
      from: ENV['GMAIL_USERNAME'],  # Add explicit from address
      subject: 'Your Trading Account Has Been Deleted'
    ) do |format|
      format.html { render 'account_deleted' }
    end
  rescue => e
    Rails.logger.error "Deletion email failed: #{e.message}"
    raise e
  end
end