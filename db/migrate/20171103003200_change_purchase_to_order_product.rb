class ChangePurchaseToOrderProduct < ActiveRecord::Migration[5.1]
  def change
    rename_table :purchases, :order_products
  end
end
