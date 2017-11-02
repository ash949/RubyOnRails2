class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.text :body
      t.decimal :rating
      t.references :product, index: true

      t.timestamps
    end
  end
end
