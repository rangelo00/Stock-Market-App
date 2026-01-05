class AddStatusToTraders < ActiveRecord::Migration[7.2]
  def change
    add_column :traders, :status, :string, default: 'pending'
    add_index :traders, :status
  end
end
