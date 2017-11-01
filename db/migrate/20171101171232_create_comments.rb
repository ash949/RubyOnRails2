class CreateComments < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.references :user, index: true, foreign_key: true
      t.text :body
      t.decimal :rating
      t.references :product, index: true,  foreign_key: true

      t.timestamps
    end
  end
end
