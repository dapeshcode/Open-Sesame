class User < ActiveRecord::Base
    has_many :user_recipes 
    has_many :recipes, through: :user_recipes

    def save_recipe
        
    end
end
