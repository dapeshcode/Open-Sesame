Category.destroy_all
RecipeCategory.destroy_all
Recipe.destroy_all
UserRecipe.destroy_all
User.destroy_all

Category.reset_pk_sequence
RecipeCategory.reset_pk_sequence
Recipe.reset_pk_sequence
UserRecipe.reset_pk_sequence
User.reset_pk_sequence

####################################################################################

    #SET OF CATEGORIES(name)

    sweet = Category.create(name: "sweet")
    savory = Category.create(name: "savory")

    #SET OF RECIPES(name, ingredients, method) -- some with notes 
        # bars, cookies, banana_bread, toast, sweet_potato
    bars = Recipe.create(name: "tahini bars", ingredients: "1 cup tahini, 1 cup coconut sugar, 2 eggs,
    2 teaspoons vanilla extract, 1/4 teaspoon salt, 3/4 cup chocolate chips/chopped chocolate, Flaky salt, for sprinkling (optional)", method: "1. Preheat oven to 350 F. Line an 8 inch square baking pan with parchment paper, leaving some excess hanging over for easy removal later. 

    2. In a large bowl, stir together the tahini and coconut sugar until smooth. Add in the eggs, vanilla extract, and salt and mix vigorously until mixture is smooth again. Stir in chocolate chips/chunks last.
    
    3. Spread batter into prepared baking pan evenly. Sprinkle more chocolate chips on top of batter if desired. Sprinkle flaky salt over batter if using. 
    
    4. Bake blondies for 23-27 minutes, until a toothpick inserted into the center of the blondies comes out with a few gooey crumbs. Don't over-bake! Let blondies cool before lifting from pan and slicing into 16-20 squares.")

    cookies = Recipe.create(name: "tahini cookies", ingredients: "1 cup tahini, 1 cup coconut sugar or 3/4 cup packed light brown sugar,
    1 egg,
    1 tablespoon vanilla extract,
    1/2 teaspoon baking soda,
    1/4 teaspoon salt,
    2/3 cup bittersweet chocolate, chopped
    Coarse salt, for sprinkling (optional)", method: "Preheat oven to 350 F. Line a baking sheet (you may want to use two sheets, the cookies spread quite a bit) with parchment paper.

    In a large bowl, stir together the tahini and coconut sugar until mixture is smooth.
    
    Stir in the egg, vanilla extract, baking soda, and salt. Be careful not to over-mix or oils from tahini will come out and make cookies spread too much. Add in chopped chocolate last. 
    
    Round tablespoons of dough between palms and place onto sheets. Don't flatten. Sprinkle a little flaky salt on top of each cookie if desired. 
    
    Bake cookies for 10 minutes, or until edges are golden. Let cookies rest on sheet for 10 minutes to firm up before moving them.")

    banana_bread = Recipe.create(name: "tahini banana bread", ingredients: "3 ripe bananas,
    2 eggs,
    1 1/4 cup sugar,
    1/3 cup canola oil,
    1/4 cup Soom Tahini,
    2 tbsp Soom Silan Date Syrup,
    1 tsp pure vanilla extract,
    1/4 cup milk of choice,
    1 3/4 cup flour,
    1 tsp baking soda,
    1/2 tsp pumpkin spice", method: "Preheat oven to 325F and spray a loaf pan with nonstick oil.
    In a large bowl, mash the bananas. Then combine mashed bananas with eggs, sugar, canola oil, tahini, silan date syrup, vanilla extract, and milk of choice.
    In a separate bowl, combine flour, baking soda, and pumpkin spice.
    Add dry ingredients to wet ingredients. Mix until well-combined, about 2 minutes.
    Pour into loaf pan and bake for 1 hour and 10 minutes.")

    toast = Recipe.create(name: "tahini feta toast", ingredients: "2 slices whole wheat bread,
    1 tablespoon tahini,
    juice of 1/2 lemon,
    1 teaspoon of water,
    2 teaspoons of crumbled feta,
    2 teaspoons of pine nuts,
    pepper", method: "In a small bowl mix the tahini with the water and lemon juice, the consistency should not be too thick (thinner than peanut butter). It should be easy to spread. If need add a bit more water.
    Toast the bread.
    Remove bread from toaster, spread a thick layer of the tahini dip, sprinkle with feta and pine nuts.
    Add pepper.")

    sweet_potato = Recipe.create(name: "tahini sweet potato", ingredients: "4 medium sweet potato (about 3 pounds),
    2 medium red onions(cut into wedges),
    3 tablespoons olive oil (not extra-virgin),
    4 tablespoons tahini paste,
    2 tablespoons lemon juice (one large lemon),
    2 tablespoons water,
    1 garlic clove,
    handful toasted pine nuts,
    1 tablespoon za’atar, 
    kosher salt & crushed black pepper to taste", method: "Preheat oven to 475 degrees F (246 C). Line a baking sheet with parchment paper.
    Wash and peel sweet potato, and cut into sixths as wedges. Peel and cut red onions into wedges. Transfer all into a bowl. Drizzle with olive oil, couple of pinches of kosher salt and crushed black pepper and gently toss to evenly distribute. Transfer onto lined baking sheet. Bake for 35 to 40 minutes.
    Meanwhile prepare the tahini dressing. Combine tahini, lemon juice, water, and a garlic clove in a food processor (mini food processor works well), pulse until smooth and pourable consistency. Add one extra tablespoon or two, if needed to reach desired consistency.")



     #SET OF USERS(name, username, password)
    alex = User.create(name: "alex", username: "peshpesh", password: "hashbrown")
    yehudis = User.create(name: "yehudis", username: "heyjude", password: "hash")
    sylwia = User.create(name: "sylwia", username: "rubyqueen", password: "domdom")
    lindsay = User.create(name: "lindsay", username: "italwayssnowsinchicago", password: "car_chairs")
    sean = User.create(name: "sean", username: "notcoffeedad", password: "sosad")


    #SET OF RECIPE/CATEGORIES(recipe_id, category_id)
    RecipeCategory.create(recipe_id: bars.id, category_id: sweet.id)
    RecipeCategory.create(recipe_id: cookies.id, category_id: sweet.id)
    RecipeCategory.create(recipe_id: banana_bread.id, category_id: sweet.id)
    RecipeCategory.create(recipe_id: banana_bread.id, category_id: savory.id)
    RecipeCategory.create(recipe_id: toast.id, category_id: savory.id)
    RecipeCategory.create(recipe_id: sweet_potato.id, category_id: savory.id)


    #SET OF USER/RECIPE(user_id, recipe_id, rating, notes) --some with rating -- some with notes
    UserRecipe.create(user_id: alex.id, recipe_id: cookies.id)
    UserRecipe.create(user_id: alex.id, recipe_id: toast.id, rating: 5, notes: "really yummy")
    UserRecipe.create(user_id: alex.id, recipe_id: banana_bread.id, rating: 5, notes: "out of this world")
    UserRecipe.create(user_id: yehudis.id, recipe_id: bars.id, rating: 5)
    UserRecipe.create(user_id: yehudis.id, recipe_id: banana_bread.id, rating: 5, notes: "make sure to use very ripe bananas")
    UserRecipe.create(user_id: sylwia.id, recipe_id: sweet_potato.id)
    UserRecipe.create(user_id: lindsay.id, recipe_id: bars.id, notes: "NOMNOM")


puts "🔥 🔥 🔥 🔥 "