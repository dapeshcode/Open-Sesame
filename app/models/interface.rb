class Interface

    attr_reader :prompt
    attr_accessor :user

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
        menu.choice "Browse All Recipes", -> {all_recipes_names}
        menu.choice "Search By Category", -> {recipes_by_category}
        menu.choice "My Saved Recipes", -> {user_recipes}
        menu.choice "Close Sesame!", -> {exit_helper}
        end
    end

    def all_recipes
        Recipe.all.map{|recipe| recipe.name}
    end

    def all_recipes_names
        prompt.select("Which recipe sounds good to you?", all_recipes)
        
    end

    def recipes_by_category

    end

    def user_recipes

    end


end


