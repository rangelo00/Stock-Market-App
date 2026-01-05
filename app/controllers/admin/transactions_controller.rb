class Admin::TransactionsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_transaction, only: [:edit, :update, :destroy]
    layout 'admin'
  
    def index
      @transactions = Transaction.includes(:trader, :stock)
                               .order(created_at: :desc)
    end
  
    def edit
        # Store original values for comparison
        session[:original_quantity] = @transaction.quantity
        session[:original_price] = @transaction.price
    end
    
    def update
        original_quantity = session[:original_quantity].to_i #integer conversion
        original_price = session[:original_price].to_f
        original_total = original_quantity * original_price
        
        # Calculate new total based on original price per share
        price_per_share = original_price # Keep the original price per share
        new_total = params[:transaction][:quantity].to_i * price_per_share
        
        @transaction.assign_attributes(
          quantity: params[:transaction][:quantity],
          price: price_per_share # Keep original price per share
        )
    
        Transaction.transaction do
          if @transaction.save
            trader = @transaction.trader
            
            # Calculate refund/charge amount
            difference = original_total - new_total
            
            # Update trader's balance based on transaction type
            if @transaction.transaction_type == 'buy'
                if difference > 0 # Quantity decreased
                  trader.update!(balance: trader.balance + difference)
                  flash[:notice] = "Transaction updated. $#{difference.round(2)} refunded to trader's balance."
                elsif difference < 0 # Quantity increased
                  if trader.balance >= difference.abs
                    trader.update!(balance: trader.balance - difference.abs)
                    flash[:notice] = "Transaction updated. $#{difference.abs.round(2)} deducted from trader's balance."
                  else
                    raise ActiveRecord::Rollback
                    flash[:alert] = "Insufficient funds in trader's balance"
                    return render :edit
                  end
                end
            elsif @transaction.transaction_type == 'sell'
                if difference > 0 # Quantity decreased
                  trader.update!(balance: trader.balance - difference)
                  flash[:notice] = "Transaction updated. $#{difference.round(2)} deducted from trader's balance."
                elsif difference < 0 # Quantity increased
                  trader.update!(balance: trader.balance + difference.abs)
                  flash[:notice] = "Transaction updated. $#{difference.abs.round(2)} added to trader's balance."
                end
            end
    
            # Recalculate portfolio
            PortfolioManager.new(trader).recalculate_portfolio
            
            redirect_to admin_dashboard_path
          else
            render :edit
          end
        end
    end
  
    def destroy
      trader = @transaction.trader
      @transaction.destroy
      # Recalculate the portfolio after transaction deletion
      PortfolioManager.new(trader).recalculate_portfolio
      redirect_to admin_dashboard_path, notice: 'Transaction was successfully deleted.'
    end
  
    private
  
    def set_transaction
      @transaction = Transaction.includes(:trader, :stock).find(params[:id])
    end
  
    def transaction_params
      params.require(:transaction).permit(:quantity, :price, :transaction_type)
    end
end