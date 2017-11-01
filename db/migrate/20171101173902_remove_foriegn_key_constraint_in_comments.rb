class RemoveForiegnKeyConstraintInComments < ActiveRecord::Migration[5.1]
  def change
    remove_foreign_key :comments, :product
    remove_foreign_key :comments, :user
  end
end
