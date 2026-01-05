class Traders::StocksController < ApplicationController
  before_action :authenticate_trader!
  before_action :set_stock, only: [:show, :buy, :sell]
  
  def index
    if params[:q].present?
      @symbol = params[:q].upcase
      
      begin
        api = AlphaVantageApi.new
        @stock_data = api.time_series_intraday(@symbol)
        
        if @stock_data.nil?
          flash.now[:alert] = "No data found for #{@symbol}. Please verify the symbol and try again."
        else
          @stock = Stock.find_or_initialize_by(symbol: @symbol)
          @stock.assign_attributes(
            current_price: @stock_data[:price].to_f,
            last_price: @stock_data[:price].to_f,
            last_price_updated_at: Time.current
          )
          
          if @stock.save
            Rails.logger.debug "Stock created/updated: #{@stock.inspect}"
          else
            Rails.logger.error "Stock save failed: #{@stock.errors.full_messages}"
            flash.now[:alert] = "Error saving stock information"
          end
        end
      rescue => e
        Rails.logger.error("Stock API Error: #{e.message}")
        Rails.logger.error(e.backtrace.join("\n"))
        flash.now[:alert] = "An error occurred while fetching data for #{@symbol}"
      end
    end
  end

  def show
    begin
      api = AlphaVantageApi.new
      @stock_data = api.time_series_intraday(@stock.symbol)
      
      if @stock_data
        @stock.update(
          current_price: @stock_data[:price].to_f,
          last_price: @stock_data[:price].to_f,
          last_price_updated_at: Time.current
        )
      end
      
      @portfolio_holding = current_trader.portfolios.find_by(stock: @stock)
    rescue => e
      Rails.logger.error("Error fetching stock data: #{e.message}")
      flash.now[:alert] = "Unable to fetch current stock data"
    end
  end

  def buy
    quantity = params[:quantity].to_i
    total_cost = @stock.current_price * quantity
    
    if quantity <= 0
      redirect_to traders_stock_path(@stock), alert: "Please enter a valid quantity"
      return
    end
    
    if current_trader.balance >= total_cost
      ActiveRecord::Base.transaction do
        # Create or update portfolio
        portfolio = current_trader.portfolios.find_or_initialize_by(stock: @stock)
        portfolio.quantity = (portfolio.quantity || 0) + quantity
        portfolio.save!
        
        # Create transaction record
        transaction = current_trader.transactions.create!(
          stock: @stock,
          quantity: quantity,
          price: @stock.current_price,
          transaction_type: 'buy',    # Make sure this is being set
          total_amount: total_cost
        )
        
        # Update trader's balance
        current_trader.update!(balance: current_trader.balance - total_cost)
        
        redirect_to traders_stock_path(@stock), notice: "Successfully bought #{quantity} shares of #{@stock.symbol}"
      end
    else
      redirect_to traders_stock_path(@stock), alert: "Insufficient funds to complete purchase"
    end
  rescue => e
    Rails.logger.error("Buy error: #{e.message}")
    redirect_to traders_stock_path(@stock), alert: "Error processing purchase"
  end
  
  def sell
    quantity = params[:quantity].to_i
    portfolio = current_trader.portfolios.find_by(stock: @stock)
    
    if quantity <= 0
      redirect_to traders_stock_path(@stock), alert: "Please enter a valid quantity"
      return
    end
    
    if portfolio&.quantity.to_i >= quantity
      total_amount = @stock.current_price * quantity
      
      ActiveRecord::Base.transaction do
        # Update portfolio
        portfolio.quantity -= quantity
        portfolio.quantity.zero? ? portfolio.destroy! : portfolio.save!
        
        # Create transaction record
        transaction = current_trader.transactions.create!(
          stock: @stock,
          quantity: quantity,
          price: @stock.current_price,
          transaction_type: 'sell',   # Make sure this is being set
          total_amount: total_amount
        )
        
        # Update trader's balance
        current_trader.update!(balance: current_trader.balance + total_amount)
        
        redirect_to traders_stock_path(@stock), notice: "Successfully sold #{quantity} shares of #{@stock.symbol}"
      end
    else
      redirect_to traders_stock_path(@stock), alert: "Insufficient shares to complete sale"
    end
  rescue => e
    Rails.logger.error("Sell error: #{e.message}")
    redirect_to traders_stock_path(@stock), alert: "Error processing sale"
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  end
end