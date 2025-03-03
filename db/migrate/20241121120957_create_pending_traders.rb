class CreatePendingTraders < ActiveRecord::Migration[7.2]
  def change
    create_table :pending_traders do |t|
      t.string :email, null: false
      t.string :encrypted_password, null: false
      
      t.timestamps
    end
    
    add_index :pending_traders, :email, unique: true
  end
end