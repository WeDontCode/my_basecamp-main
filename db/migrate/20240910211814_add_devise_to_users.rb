class AddDeviseToUsers < ActiveRecord::Migration[6.0]
  def up
    change_table :users do |t|
      # Do not add email since it's already in the users table
      unless column_exists?(:users, :encrypted_password)
        t.string :encrypted_password, null: false, default: ""
      end
      # Add any other Devise-related fields if needed
    end
  end

  def down
    change_table :users do |t|
      # Do not remove email since it's managed by another migration
      t.remove :encrypted_password if column_exists?(:users, :encrypted_password)
      # Remove any other Devise-related fields if needed
    end
  end
end
