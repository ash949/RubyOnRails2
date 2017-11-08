class AddStatusToOrders < ActiveRecord::Migration[5.1]
  def change
    change_table :orders do |t|
      t.references :status, index: true
    end
  end
end
