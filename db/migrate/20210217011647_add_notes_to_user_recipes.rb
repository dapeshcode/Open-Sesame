class AddNotesToUserRecipes < ActiveRecord::Migration[5.2]
  def change
    add_column :user_recipes, :notes, :text
  end
end
