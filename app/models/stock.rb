class Stock < ApplicationRecord
  has_many :portfolios
  has_many :traders, through: :portfolios
  has_many :transactions

  validates :symbol, presence: true, uniqueness: true
  validates :current_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def market_value
    current_price || last_price
  end

  def price_changed?
    last_price && current_price && last_price != current_price
  end

  def price_change_percentage
    return nil unless price_changed?
    ((current_price - last_price) / last_price * 100).round(2)
  end
end