class Portfolio < ApplicationRecord
  belongs_to :trader
  belongs_to :stock

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def current_value
    quantity * stock.current_price
  end
end