class CreateBranches < ActiveRecord::Migration[5.1]
  def change
    create_table :branches do |t|
      t.string :name
      t.decimal :lat
      t.decimal :lng
    end
  end
end
