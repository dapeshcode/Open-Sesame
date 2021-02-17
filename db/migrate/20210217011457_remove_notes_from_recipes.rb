class RemoveNotesFromRecipes < ActiveRecord::Migration[5.2]
  def change
    remove_column :recipes, :notes
  end
end
