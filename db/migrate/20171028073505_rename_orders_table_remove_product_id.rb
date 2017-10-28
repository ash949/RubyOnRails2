class RenameOrdersTableRemoveProductId < ActiveRecord::Migration[5.1]
  def change
    rename_table :orders_tables, :orders
    remove_column :orders, :product_id
  end
end
