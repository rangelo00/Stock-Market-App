class Trader < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :portfolios
  has_many :transactions
  has_many :stocks, through: :portfolios

  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  def can_afford?(amount)
    balance >= amount
  end

  enum status: {
    pending: 'pending',
    approved: 'approved',
    rejected: 'rejected'
  }

  def active_for_authentication?
    super && approved?
  end

  def inactive_message
    approved? ? super : :not_approved
  end

  def formatted_balance
    ActionController::Base.helpers.number_to_currency(balance)
  end

  # Set default status to pending on creation
  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= :pending
  end
end
