class AddProductIdToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :product_id, :integer
  end
  add_index :orders, :product_id
end
