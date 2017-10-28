class RemoveProductIdFromOrders < ActiveRecord::Migration[5.1]
  def change
    remove_column :orders, :product_id
  end
  remove_index :orders, :product_id
end
