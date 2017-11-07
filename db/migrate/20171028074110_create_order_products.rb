class CreateOrderProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :order_products do |t|
      t.integer :order_id
      t.integer :product_id
    end
    add_index :order_products, :order_id
    add_index :order_products, :product_id
  end
end
