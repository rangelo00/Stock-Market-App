class Traders::EmailPreviewsController < ApplicationController
    before_action :authenticate_trader!
    layout 'traders'
  
    def show
      preview_path = Rails.root.join('tmp', 'mail', 'email_notify.html')
      if File.exist?(preview_path)
        @email_content = File.read(preview_path)
        # Clean up the file after reading
        File.delete(preview_path)
      else
        redirect_to admin_dashboard_index_path, alert: 'Email preview not available'
      end
    end
  end