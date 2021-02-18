class User < ActiveRecord::Base
    has_many :user_recipes 
    has_many :recipes, through: :user_recipes

    def save_recipe
        self.user_recipes
    end
end

#list of user recipe instances
# compare for recipe id
# delete the matching instance

