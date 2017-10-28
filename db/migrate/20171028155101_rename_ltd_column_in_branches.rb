class RenameLtdColumnInBranches < ActiveRecord::Migration[5.1]
  def change
    rename_column :branches, :ltd, :lat
  end
end
