class Interface

    attr_reader :prompt
    attr_accessor :user

    @@recipe_to_save = 0 

    def initialize
        @prompt = TTY::Prompt.new
    end
    
    def welcome
        Logo.animation
        sleep(0.5)
        login
    end

    def login
        puts "\n\n\n"
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
            puts "\n\n\n"
            puts "Welcome back to the cave, #{self.user.name.capitalize}!"
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
        puts "\n\n\n"
        name = prompt.ask("Enter Name:")
        username = prompt.ask("Enter Username:")
        while User.find_by(username: username)
            prompt.error("This username is already taken.")
            puts "\n"
            username = prompt.ask("Enter Username:")
        end
        password = prompt.mask("Enter Password:")
        self.user = User.create(name: name, username: username, password: password)
        puts "\n\n\n"
        prompt.say("Welcome #{self.user.name.capitalize}! You are now entering the cave!")
        sleep(2)
        puts "\n\n\n"
        main_menu
    end

    def main_menu
        puts "\n"
        prompt.select("What would you like to do?") do |menu|
        menu.choice "Browse All Recipes", -> {all_recipe_names}
        menu.choice "Search By Category", -> {recipes_by_category}
        menu.choice "My Saved Recipes", -> {user_recipes}
        menu.choice "Close Sesame!", -> {exit_helper}
        end
    end

    def all_recipe_names
        puts "\n"
        menu_choice = prompt.select("Which recipe sounds good to you?", Recipe.all_recipes)
        recipe = Recipe.find_by_name(menu_choice)
        @@recipe_to_save = recipe.id
        recipe_card = "\n\n #{recipe.name.upcase}\n\n\n #{recipe.ingredients}\n\n\n #{recipe.method}\n"
        puts "\n"
        box(recipe_card)
        sleep(1)
        individual_recipe_helper   
    end

    def recipes_by_category
        puts "\n"
        input = prompt.select("What are you in the mood for?", Category.all_category_names)
        show_list_array = Category.find_by(name: input)
        puts "\n"
        recipe = prompt.select("select a recipe", show_list_array.show_recipe_name)
        recipe_instance = Recipe.find_by_name(recipe)
        view_category_individual_recipe(recipe_instance)
    end

    def view_category_individual_recipe(recipe)
        puts "\n"
        recipe_card = "\n\n #{recipe.name.upcase}\n\n\n #{recipe.ingredients}\n\n\n #{recipe.method}\n"
        puts "\n"
        box(recipe_card)
        puts "\n"
        sleep(1)
        category_recipe_helper
    end

    def category_recipe_helper
        puts "\n"
        prompt.select("What would you like to do?") do |menu|
            menu.choice "Save This Recipe", -> {save_recipe}
            menu.choice "Continue Browsing", -> {recipes_by_category}
            menu.choice "Back to Main", -> {main_menu}
            menu.choice "Close Sesame!", -> {exit_helper}
        end
    end

    def user_recipes
        recipe_choice = prompt.select("Here are your saved recipes:", user_recipe_names)
        recipe = Recipe.find_by_name(recipe_choice)
        puts "\n"
        prompt.select("What would you like to do with this recipe?") do |menu|
            menu.choice "Show me the recipe", -> {view_individual_recipe(recipe)}
            menu.choice "Add a note", -> {update_recipe(user_id: self.user.id, recipe_id: recipe.id)}
            menu.choice "Remove from my recipes", -> {remove_recipe(user_id: self.user.id, recipe_id: recipe.id)}
            menu.choice "Return to main menu", -> {main_menu}
        end 
    end

    def user_recipe_names
        self.user.recipes.map(&:name).uniq
    end

    def view_individual_recipe(recipe)
        recipe_card = "\n\n #{recipe.name.upcase}\n\n\n #{recipe.ingredients}\n\n\n #{recipe.method}\n"
        puts "\n"
        box(recipe_card)
        user_recipe_instance = UserRecipe.find_by(user_id: user.id, recipe_id: recipe.id)
        puts "🤓 NOTES: " + user_recipe_instance.notes if user_recipe_instance.notes != nil
        puts "\n"
        sleep(1)
        user_recipes
    end 

    def individual_recipe_helper
        puts "\n"
        prompt.select("What would you like to do?") do |menu|
            menu.choice "Save This Recipe", -> {save_recipe}
            menu.choice "Continue Browsing", -> {all_recipe_names}
            menu.choice "Back to Main", -> {main_menu}
            menu.choice "Close Sesame!", -> {exit_helper}
        end
    end

    def remove_recipe(user_recipe_hash)
        UserRecipe.find_by(user_recipe_hash).destroy
        puts "\n"
        puts "💣 💣 💣 💣 💣 💣 💣 💣  a recipe in reci-pieces"
        puts "\n"
        main_menu
    end 

    def update_recipe(user_recipe_hash)
        puts "\n"
        input = prompt.ask("Add Note:")
        UserRecipe.find_by(user_recipe_hash).update(notes: input)
        puts "✅ Your note has been added ✅ "
        sleep(1)
        puts "\n"
        user_recipes
    end

    def save_recipe
        UserRecipe.create(user_id: self.user.id, recipe_id: @@recipe_to_save)
        puts "\n"
        puts "⭐️ This recipe has been added to your tahini cave!⭐️ "
        sleep(1)
        puts "\n"
        saved_recipe_helper
    end

    def saved_recipe_helper
        puts "\n"
        prompt.select("What would you like to do?") do |menu|
            menu.choice "Back to main", -> {main_menu}
            menu.choice "Close Sesame!", -> {exit_helper}
        end
    end

    def exit_helper
        Logo.exit
    end

    def box(content)
       border = TTY::Box.frame(width: 50, height: 35, title: {top_left: "SESAME RECIPE"}) do
             content
        end
        puts border
    end

end 

