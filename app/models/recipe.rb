class Recipe < ActiveRecord::Base
  has_many :user_recipes
  has_many :users, through: :user_recipes
  has_many :recipe_categories 
  has_many :categories, through: :recipe_categories
end
