class Interface

    attr_reader :prompt
    attr_accessor :user

    @@recipe_to_save = 0 

    def initialize
        @prompt = TTY::Prompt.new
    end
    
    def welcome
        puts "Open Sesame!"
        login
    end

    def login
        prompt.select("Login here or create new account") do |menu|
            menu.choice "Log In", -> {log_in_helper}
            menu.choice "Sign Up", -> {sign_up_helper}
            menu.choice "Exit", -> {exit_helper}
        end
    end

    def log_in_helper
        username = prompt.ask("Enter Username:".colorize(:color => :white, :background => :light_blue))
        password = prompt.mask("Enter Password:")
        if User.find_by(username: username, password: password)
            self.user = User.find_by(username: username, password: password)
            puts "Welcome Back #{self.user.name.capitalize}!"
            sleep(1)
            puts "\n"
            main_menu
        else
            prompt.error("Incorrect Username or Password")
            sleep(1)
            puts "\n"
            log_in_helper
        end
    end

    def sign_up_helper
        name = prompt.ask("Enter Name:")
        username = prompt.ask("Enter Username:")
        while User.find_by(username: username)
            prompt.error("This username is already taken.")
            puts "\n"
            username = prompt.ask("Enter Username:")
        end
        password = prompt.mask("Enter Password:")
        self.user = User.create(name: name, username: username, password: password)
        prompt.say("Welcome #{self.user.name.capitalize}! You have joined the tahini club ")
        sleep(2)
        main_menu
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
        puts "\n"
        sleep(1)
        individual_recipe_helper   
    end

    def recipes_by_category
        input = prompt.select("What are you in the mood for?", Category.all_category_names)
        show_list_array = Category.find_by(name: input)
        recipe = prompt.select("select a recipe", show_list_array.show_recipe_name)
        recipe_instance = Recipe.find_by_name(recipe)
        view_category_individual_recipe(recipe_instance)
    end

    def category_recipe_helper
        prompt.select("What would you like to do?") do |menu|
            menu.choice "Save This Recipe", -> {save_recipe}
            menu.choice "Continue Browsing", -> {recipes_by_category}
            menu.choice "Back to Main", -> {main_menu}
            menu.choice "Close Sesame!", -> {exit_helper}
        end
    end

    def view_category_individual_recipe(recipe)
        user_recipe_instance = UserRecipe.find_by(user_id: user.id, recipe_id: recipe.id)
        puts "\n"
        puts "🗒 NOTES: " + user_recipe_instance.notes if user_recipe_instance.notes != nil
        puts "\n"
        sleep(1)
        category_recipe_helper
    end

    def user_recipes
        recipe_choice = prompt.select("Here are your saved recipes:", user_recipe_names)
        recipe = Recipe.find_by_name(recipe_choice)
        prompt.select("What would you like to do with this recipe?") do |menu|
            menu.choice "Show me the recipe", -> {view_individual_recipe(recipe)}
            menu.choice "Add a note", -> {update_recipe(user_id: self.user.id, recipe_id: recipe.id)}
            menu.choice "Remove from my cave", -> {remove_recipe(user_id: self.user.id, recipe_id: recipe.id)}
            menu.choice "Return to main menu", -> {main_menu}
        end 
    end

    def user_recipe_names
        self.user.recipes.map(&:name).uniq
    end

    def view_individual_recipe(recipe)
        puts recipe.name.upcase
        puts recipe.ingredients
        puts recipe.method
        puts "\n"
        user_recipe_instance = UserRecipe.find_by(user_id: user.id, recipe_id: recipe.id)
        puts "🗒 NOTES: " + user_recipe_instance.notes if user_recipe_instance.notes != nil
        puts "\n"
        sleep(1)
        user_recipes
    end 

    def individual_recipe_helper
        prompt.select("What would you like to do?") do |menu|
            menu.choice "Save This Recipe", -> {save_recipe}
            menu.choice "Continue Browsing", -> {all_recipe_names}
            menu.choice "Back to Main", -> {main_menu}
            menu.choice "Close Sesame!", -> {exit_helper}
        end
    end

    def remove_recipe(user_recipe_hash)
        UserRecipe.find_by(user_recipe_hash).destroy
        puts "Recipe has been removed"
        main_menu
    end 

    def update_recipe(user_recipe_hash)
        input = prompt.ask("Add Note:")
        UserRecipe.find_by(user_recipe_hash).update(notes: input)
        puts "✅ Your note has been added ✅ "
        sleep(1)
        puts "\n"
        user_recipes
    end

    def save_recipe
        UserRecipe.create(user_id: self.user.id, recipe_id: @@recipe_to_save)
        puts "⭐️ This recipe has been added to your tahini cave!⭐️ "
        sleep(1)
        puts "\n"
        saved_recipe_helper
    end

    def saved_recipe_helper
        prompt.select("What would you like to do?") do |menu|
            menu.choice "Back to main", -> {main_menu}
            menu.choice "Close Sesame!", -> {exit_helper}
        end
    end

    def exit_helper
        puts "Close Sesame!"
    end
end 

