class AddPasswordResetTokenToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :password_reset_token, :string
    add_index :users, :password_reset_token
  end
end
