class Traders::TransactionsController < ApplicationController
  before_action :authenticate_trader!

  def index
    @transactions = current_trader.transactions.includes(:stock).order(created_at: :desc)
  end
end