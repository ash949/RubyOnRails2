class CreateOrdersTable < ActiveRecord::Migration[5.1]
  def change
    create_table :orders_tables do |t|
      t.integer :user_id
      t.integer :product_id
      t.decimal :total_cost
    end
    add_index :orders_tables, :user_id
    add_index :orders_tables, :product_id
  end
end
