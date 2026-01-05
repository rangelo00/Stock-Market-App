class ChangeNameNullConstraintInStocks < ActiveRecord::Migration[7.2]
  def change
    change_column_null :stocks, :name, true
    change_column_null :stocks, :last_price, true
    change_column_null :stocks, :last_price_updated_at, true
  end
end
