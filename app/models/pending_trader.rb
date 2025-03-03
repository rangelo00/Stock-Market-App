class PendingTrader < ApplicationRecord
  validates :email, presence: true, uniqueness: true
  validates :encrypted_password, presence: true

  DEFAULT_STARTING_BALANCE = 10_000.00

  def approve!
    Trader.transaction do
      # Generate a random password for initial creation
      temp_password = SecureRandom.hex(10)
      
      trader = Trader.new(
        email: email,
        password: temp_password,  # Use temporary password for validation
        password_confirmation: temp_password,
        status: 'approved',
        balance: DEFAULT_STARTING_BALANCE
      )

      # Set the encrypted password after initialization
      trader.encrypted_password = encrypted_password
      
      if trader.save
        self.destroy
        trader
      else
        raise ActiveRecord::Rollback
      end
    end
  end
end