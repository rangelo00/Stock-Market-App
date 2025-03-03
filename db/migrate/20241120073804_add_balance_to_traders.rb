class AddBalanceToTraders < ActiveRecord::Migration[7.0]
  def change
    add_column :traders, :balance, :decimal, precision: 10, scale: 2, default: 10000.00, null: false
  end
end
