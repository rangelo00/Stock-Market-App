class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!
  layout 'admin'

  def index
    @total_traders = Trader.count
    @total_transactions = Transaction.count
    @total_trading_volume = Transaction.sum('quantity * price')
    
    # Change this line to use PendingTrader model
    @pending_traders = PendingTrader.all
    
    @recent_traders = Trader.includes(:portfolios, :transactions)
                          .order(created_at: :desc)
                          .limit(5)
                          
    @recent_transactions = Transaction.includes(:trader, :stock)
                                    .order(created_at: :desc)
                                    .limit(5)
  end
end