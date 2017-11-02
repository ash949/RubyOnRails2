class ChangeRatingToInteger < ActiveRecord::Migration[5.1]
  def change
    change_column :comments, :rating, :integer
  end
end
