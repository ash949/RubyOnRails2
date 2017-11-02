class RenameOrderProductRecord < ActiveRecord::Migration[5.1]
  def change
    rename_table :order_product_records, :purchases
  end
end
