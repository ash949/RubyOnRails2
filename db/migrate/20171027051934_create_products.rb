class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :image_url
      t.text :description
      t.text :features
      t.integer :price_in_cents
      t.text :showcase_images

      t.timestamps
    end
  end
end
