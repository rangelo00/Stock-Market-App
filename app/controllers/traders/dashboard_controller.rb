class Traders::DashboardController < ApplicationController
    before_action :authenticate_trader!
  
    def index
      @portfolio_value = calculate_portfolio_value
      @recent_transactions = current_trader.transactions.includes(:stock).order(created_at: :desc).limit(5)
      @recent_stocks = current_trader.stocks.distinct.order(updated_at: :desc).limit(5)
  
      if params[:q].present?
        @symbol = params[:q].upcase
        begin
          api = AlphaVantageApi.new
          @stock_data = api.time_series_intraday(@symbol)
          
          if @stock_data.nil?
            flash.now[:alert] = "No data found for #{@symbol}. Please verify the symbol and try again."
          else
            @stock = Stock.find_or_create_by(symbol: @symbol) do |stock|
              stock.current_price = @stock_data[:price].to_f
            end
          end
        rescue => e
          Rails.logger.error("Stock API Error: #{e.message}")
          flash.now[:alert] = "An error occurred while fetching data for #{@symbol}"
        end
      end
    end
  
    private
  
    def calculate_portfolio_value
      current_trader.portfolios.sum do |portfolio|
        portfolio.quantity * portfolio.stock.current_price
      end
    end
  end