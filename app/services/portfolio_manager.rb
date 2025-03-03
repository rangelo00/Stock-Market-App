# app/services/portfolio_manager.rb
class PortfolioManager
    def initialize(trader)
      @trader = trader
    end
  
    def recalculate_portfolio
      # Clear existing portfolios
      @trader.portfolios.destroy_all
      
      # Group all transactions by stock
      stock_quantities = {}
      
      @trader.transactions.includes(:stock).each do |transaction|
        stock_quantities[transaction.stock_id] ||= 0
        if transaction.transaction_type == 'buy'
          stock_quantities[transaction.stock_id] += transaction.quantity
        else
          stock_quantities[transaction.stock_id] -= transaction.quantity
        end
      end
      
      # create new portfolio entries
      stock_quantities.each do |stock_id, quantity|
        if quantity > 0
          @trader.portfolios.create!(
            stock_id: stock_id,
            quantity: quantity
          )
        end
      end
    end
  end