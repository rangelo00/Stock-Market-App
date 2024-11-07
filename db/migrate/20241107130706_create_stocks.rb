class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.string :company_name
      t.float :current_price
      t.datetime :last_updated

      t.timestamps
    end
  end
end
