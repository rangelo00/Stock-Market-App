class CreatePortfolios < ActiveRecord::Migration[7.2]
  def change
    create_table :portfolios do |t|
      t.references :trader, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 0

      t.timestamps
    end
    add_index :portfolios, [:trader_id, :stock_id], unique: true
  end
end