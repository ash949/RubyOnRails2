class RemoveEmailPasswordColumnsFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :email
    remove_column :users, :password
  end
end
