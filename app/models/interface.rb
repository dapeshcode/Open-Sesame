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
        #menu.choice "Edit My Recipes", -> ,{edit_recipes_helper}
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

    end

    def user_recipe_names
        self.user.recipes.map(&:name).uniq
    end

    def user_recipes
          #UserRecipe = where user_id == self.id, return recipes
          recipe_choice = prompt.select("Here are your saved recipes:", user_recipe_names)
          recipe = Recipe.find_by_name(recipe_choice)
          puts recipe.name
          puts recipe.ingredients
          puts recipe.method
          updating_recipe_helper   
    end

    def updating_recipe_helper
        user_choice = prompt.select("What would you like to do?") do |menu|
            menu.choice "Add a Rating or Comments", -> {update_recipe}
            menu.choice "Remove From My Recipes", -> {delete_user_recipe(recipe)}
            menu.choice "Back to My Recipes", -> {user_recipes}
            menu.choice "Back to Main", -> {main_menu}
            menu.choice "Close Sesame!", -> {exit_helper}
        end
    end

    def update_recipe
        #updated instance of UserRecipe - adding comment

    end

    def delete_user_recipe(recipe)
        binding.pry
        delete_recipe
    end


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


