class AddCurrentPriceToStocks < ActiveRecord::Migration[7.2]
  def change
    add_column :stocks, :current_price, :decimal, precision: 10, scale: 2
  end
end