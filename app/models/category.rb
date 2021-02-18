class Category < ActiveRecord::Base
    has_many :recipe_categories 
    has_many :recipes, through: :recipe_categories

    def self.all_category_names
      self.all.map(&:name)
    end

    def show_recipes_in_one_category
      RecipeCategory.where(category_id: self.id)
    end 

    def show_full_recipe 
      show_recipes_in_one_category.map(&:recipe)
    end 

    def show_recipe_name
      show_full_recipe.map(&:name)
    end 
  end

