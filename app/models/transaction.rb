class Transaction < ApplicationRecord
  belongs_to :trader
  belongs_to :stock

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :transaction_type, presence: true

  scope :recent, -> { order(created_at: :desc) }

  def total_amount
    quantity * price
  end

  # Helper method to check if it's a buy transaction
  def buy?
    transaction_type == 'buy'
  end

  # Helper method to check if it's a sell transaction
  def sell?
    transaction_type == 'sell'
  end
end