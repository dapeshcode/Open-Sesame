class Interface

    attr_reader :prompt
    attr_accessor :user

    @@recipe_to_save = 0 

def initialize
    @prompt = TTY::Prompt.new
end
@@recipe_to_save = 0 



def welcome
    puts "Open Sesame!"
    login
end

def login
    #match username, and match password, if !match return error
   prompt.select("Login here or create new account") do |menu|
        menu.choice "Log In", -> {log_in_helper}
        menu.choice "Sign Up", -> {sign_up_helper}
        menu.choice "Exit", -> {exit_helper}
     end
end

def log_in_helper
    username = prompt.ask("Enter Username:")
    password = prompt.mask("Enter Password:")
    if User.find_by(username: username, password: password)
        self.user = User.find_by(username: username, password: password)
        puts "Welcome Back #{self.user.name}!"
        sleep(2)
        main_menu
    else
        prompt.error("Incorrect Username or Password")
        sleep(1)
        log_in_helper
    end
end

def sign_up_helper
    name = prompt.ask("Enter Name:")
    username = prompt.ask("Enter Username:")
    while User.find_by(username: username)
        prompt.error("This username is already taken.")
        username = prompt.ask("Enter Username:")
    end
    password = prompt.mask("Enter Password:")
    self.user = User.create(name: name, username: username, password: password)
    prompt.say("Welcome #{self.user.name}! You have joined the tahini club")
    sleep(2)
    main_menu
end

def exit_helper
    puts "Close Sesame!"
    # sleep(1)
    # logo
    # stop_music
    # sleep(1)
end

def main_menu
    prompt.select("What would you like to do?") do |menu|
    menu.choice "Browse All Recipes", -> {all_recipe_names}
    menu.choice "Search By Category", -> {recipes_by_category}
    menu.choice "My Saved Recipes", -> {user_recipes}
    menu.choice "Close Sesame!", -> {exit_helper}
    end
end

def all_recipe_names
    menu_choice = prompt.select("Which recipe sounds good to you?", Recipe.all_recipes)
    recipe = Recipe.find_by_name(menu_choice)
    @@recipe_to_save = recipe.id
    puts recipe.name
    puts recipe.ingredients
    puts recipe.method
    individual_recipe_helper   
end

def edit_recipes_helper
    user_input = prompt.select("Update or Remove",[update, remove])
end


def recipes_by_category
    input = prompt.select("What are you in the mood for?", Category.all_category_names)
    binding.pry

end

def user_recipe_names
    self.user.recipes.map(&:name).uniq
end

def view_individual_recipe(recipe)
    puts recipe.name
    puts recipe.ingredients
    puts recipe.method
    user_recipe_instance = UserRecipe.find_by(user_id: user.id, recipe_id: recipe.id)
    puts "NOTES: " + user_recipe_instance.notes if user_recipe_instance.notes != nil
    user_recipes
    
end 

def remove_recipe(user_recipe_hash)
    UserRecipe.find_by(user_recipe_hash).destroy
    puts "Recipe has been removed"
    main_menu
end 
   
    

def user_recipes
      #UserRecipe = where user_id == self.id, return recipes
      recipe_choice = prompt.select("Here are your saved recipes:", user_recipe_names)
      recipe = Recipe.find_by_name(recipe_choice)
      prompt.select("What would you like to do with this recipe?") do |menu|
        menu.choice "view", -> {view_individual_recipe(recipe)}
        menu.choice "add note", -> {update_recipe(user_id: self.user.id, recipe_id: recipe.id)}
        menu.choice "remove", -> {remove_recipe(user_id: self.user.id, recipe_id: recipe.id)}
        menu.choice "back to main menu", -> {main_menu}
      end 
        
end

# def updating_recipe_helper
#     user_choice = prompt.select("What would you like to do?") do |menu|
#         menu.choice "Add a Rating or Comments", -> {update_recipe}
#         menu.choice "Remove From My Recipes", -> {delete_user_recipe(recipe)}
#         menu.choice "Back to My Recipes", -> {user_recipes}
#         menu.choice "Back to Main", -> {main_menu}
#         menu.choice "Close Sesame!", -> {exit_helper}
#     end
# end

def update_recipe(user_recipe_hash)
    input = prompt.ask("Add Note:")
    UserRecipe.find_by(user_recipe_hash).update(notes: input)
    puts "Note Added!!!"
    user_recipes

end

# def delete_user_recipe(recipe)
#     binding.pry
#     delete_recipe
# end


def individual_recipe_helper
    prompt.select("What would you like to do?") do |menu|
        menu.choice "Save This Recipe", -> {save_recipe}
        menu.choice "Continue Browsing", -> {all_recipe_names}
        menu.choice "Back to Main", -> {main_menu}
        menu.choice "Close Sesame!", -> {exit_helper}
    end
end

def save_recipe
    UserRecipe.create(user_id: self.user.id, recipe_id: @@recipe_to_save)
    puts "⭐️ Added to your tahini recipe stash!⭐️ "
    saved_recipe_helper
end

def saved_recipe_helper
    prompt.select("What would you like to do?") do |menu|
        menu.choice "Continue Browsing", -> {all_recipe_names}
        menu.choice "Back to Main", -> {main_menu}
        menu.choice "Close Sesame!", -> {exit_helper}
    end

end
end 

