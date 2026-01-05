class Traders::PortfoliosController < ApplicationController
    before_action :authenticate_trader!
    
    def index
      @portfolios = current_trader.portfolios.includes(:stock)
      @total_value = @portfolios.sum(&:current_value)
    end
  end