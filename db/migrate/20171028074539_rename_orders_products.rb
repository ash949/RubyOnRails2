class RenameOrdersProducts < ActiveRecord::Migration[5.1]
  def change
    rename_table :orders_products, :order_product_records
  end
end
