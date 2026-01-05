class Traders::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def create
    # Build the resource but don't save it
    build_resource(sign_up_params)

    PendingTrader.transaction do
      @pending_trader = PendingTrader.new(
        email: sign_up_params[:email],
        encrypted_password: resource.encrypted_password
      )

      if @pending_trader.save
        # Ensure no session is created
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
        
        # Clean up the unsaved resource
        self.resource = resource_class.new
        
        flash[:notice] = 'Thanks for signing up! You will be notified when your account is approved.'
        redirect_to new_trader_session_path and return
      else
        clean_up_passwords resource
        set_minimum_password_length
        flash[:alert] = @pending_trader.errors.full_messages.join(", ")
        render :new
      end
    end
  rescue => e
    flash[:alert] = "Registration failed: #{e.message}"
    render :new
  end

  # Completely override the sign_up method
  def sign_up(resource_name, resource)
    # Do nothing - prevents Devise's default sign-up behavior
    true
  end

  protected

  # Prevent Devise's default behavior after sign up
  def after_sign_up_path_for(resource)
    new_trader_session_path
  end

  def after_inactive_sign_up_path_for(resource)
    new_trader_session_path
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:email])
  end

  # Override Devise's default behavior
  def respond_to_on_destroy
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
    end
  end
end