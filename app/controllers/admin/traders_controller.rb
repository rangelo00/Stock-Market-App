class Admin::TradersController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_trader, only: [:show, :destroy]
    layout 'admin'
  
    def index
      @traders = Trader.includes(:portfolios, :transactions)
                      .order(created_at: :desc)
      @pending_traders = PendingTrader.order(created_at: :desc)  # Add this line
    end
  
    def show
      @transactions = @trader.transactions.includes(:stock).order(created_at: :desc)
      @portfolios = @trader.portfolios.includes(:stock)
      @total_portfolio_value = @portfolios.sum { |p| p.quantity * p.stock.current_price }
    end
  
    def approve
      @pending_trader = PendingTrader.find(params[:id])
      
      if @trader = @pending_trader.approve!
        TraderMailer.account_approved(@trader).deliver_later #approval mail
        redirect_to admin_traders_path, notice: 'Trader was successfully approved.'
      else
        redirect_to admin_traders_path, alert: 'Error approving trader.'
      end
    end
  
    def reject
      @pending_trader = PendingTrader.find(params[:id])
      TraderMailer.account_rejected(@pending_trader).deliver_later
      if @pending_trader.destroy
        redirect_to admin_traders_path, notice: 'Registration was rejected.'
      else
        redirect_to admin_traders_path, alert: 'Error rejecting registration.'
      end
    end

    def destroy
      if @trader.destroy
        # Optionally send an email notification
        TraderMailer.account_deleted(@trader).deliver_later
        redirect_to admin_traders_path, notice: 'Trader was successfully deleted.'
      else
        redirect_to admin_traders_path, alert: 'Error deleting trader.'
      end
    end  
  
    private
  
    def set_trader
      @trader = Trader.find(params[:id])
    end
  end