class AddNotNullConstraintToLoginInUsers < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :login, :string, null: false
  end
end
