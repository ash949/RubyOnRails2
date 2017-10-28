class CreateBranches < ActiveRecord::Migration[5.1]
  def change
    create_table :branches do |t|
      t.string :name
      t.decimal :ltd
      t.decimal :lng
    end
  end
end
