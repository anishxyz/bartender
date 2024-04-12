//
//  SampleRecipes.swift
//  bartender
//
//  Created by Anish Agrawal on 4/12/24.
//

import Foundation


protocol CocktailRecipeProtocol {
    static var recipe: CocktailRecipe { get }
    static var ingredients: [Ingredient] { get }
    static var recipeSteps: [RecipeStep] { get }
    static var recipeSections: [RecipeSection] { get }
}


struct spicyMargarita: CocktailRecipeProtocol {
    
    static var recipe: CocktailRecipe = CocktailRecipe(name: "Spicy Margarita")
    
    static var ingredients: [Ingredient] = [
        Ingredient(name: "Tequila", quantity: 2, units: .ounces, type: .tequila),
        Ingredient(name: "Lime Juice", quantity: 1, units: .ounces, type: .mixer),
        Ingredient(name: "Agave Syrup", quantity: 0.5, units: .ounces, type: .mixer),
        Ingredient(name: "Jalapeno", quantity: 3, units: .slices, type: .garnish)
    ]
    
    static var recipeSteps: [RecipeStep] = [
        RecipeStep(instruction: "Muddle the jalapeno slices in the shaker."),
        RecipeStep(instruction: "Add tequila, lime juice, and agave syrup to shaker with ice."),
        RecipeStep(instruction: "Shake well."),
        RecipeStep(instruction: "Strain into a chilled glass.")
    ]
    
    static var recipeSections = [RecipeSection(title: "Preparation")]
    
    static func setupRelationships() {
        recipe.ingredients = ingredients
        recipe.sections = recipeSections
        recipeSections[0].steps = recipeSteps
    }
}


struct newYorkSour: CocktailRecipeProtocol {
    
    static var recipe: CocktailRecipe = CocktailRecipe(name: "New York Sour")
    
    static var ingredients: [Ingredient] = [
        Ingredient(name: "Whiskey", quantity: 2, units: .ounces, type: .whiskey),
        Ingredient(name: "Lemon Juice", quantity: 1, units: .ounces, type: .mixer),
        Ingredient(name: "Simple Syrup", quantity: 0.5, units: .ounces, type: .mixer),
        Ingredient(name: "Red Wine", quantity: 0.5, units: .ounces, type: .mixer)
    ]
    
    static var recipeSteps: [RecipeStep] = [
        RecipeStep(instruction: "Combine whiskey, lemon juice, and simple syrup in a shaker."),
        RecipeStep(instruction: "Fill the shaker with ice and shake until well chilled."),
        RecipeStep(instruction: "Strain into a rocks glass filled with fresh ice."),
        RecipeStep(instruction: "Gently pour red wine over the back of a spoon so it floats on top of the drink.")
    ]
    
    static var recipeSections: [RecipeSection] = [
        RecipeSection(title: "Mixing"),
        RecipeSection(title: "Finishing Touches")
    ]
    
    static func setupRelationships() {
        recipe.ingredients = ingredients
        recipe.sections = recipeSections
        recipeSections[0].steps = Array(recipeSteps.prefix(3))
        recipeSections[1].steps = Array(recipeSteps.suffix(1))
    }
}


struct goldenHour: CocktailRecipeProtocol {
    
    static var recipe: CocktailRecipe = CocktailRecipe(name: "The Golden Hour")
    
    static var ingredients: [Ingredient] = [
        Ingredient(name: "Aged Rum", quantity: 2, units: .ounces, type: .rum),
        Ingredient(name: "Saffron-Infused Simple Syrup", quantity: 0.75, units: .ounces, type: .mixer),
        Ingredient(name: "Champagne", quantity: 1, units: .ounces, type: .mixer),
        Ingredient(name: "Lemon Juice", quantity: 0.5, units: .ounces, type: .mixer),
        Ingredient(name: "Egg White", quantity: 1, units: .eggs, type: .other),
        Ingredient(name: "Edible Gold Leaf", quantity: 1, units: .leaves, type: .garnish)
    ]
    
    static var recipeSteps: [RecipeStep] = [
        RecipeStep(instruction: "In a shaker, combine aged rum, saffron-infused simple syrup, lemon juice, and egg white."),
        RecipeStep(instruction: "Dry shake (without ice) vigorously for 30 seconds to emulsify the egg white."),
        RecipeStep(instruction: "Add ice to the shaker and shake again until well chilled."),
        RecipeStep(instruction: "Strain into a coupe glass."),
        RecipeStep(instruction: "Top with champagne."),
        RecipeStep(instruction: "Carefully place an edible gold leaf on the foam for garnish.")
    ]
    
    static var recipeSections: [RecipeSection] = [
        RecipeSection(title: "Mixing"),
        RecipeSection(title: "Finishing Touches")
    ]
    
    static func setupRelationships() {
        recipe.ingredients = ingredients
        recipe.sections = recipeSections
        recipeSections[0].steps = Array(recipeSteps.prefix(4))
        recipeSections[1].steps = Array(recipeSteps.suffix(2))
    }
}


struct espressoMartini: CocktailRecipeProtocol {
    
    static var recipe: CocktailRecipe = CocktailRecipe(name: "Espresso Martini")
    
    static var ingredients: [Ingredient] = [
        Ingredient(name: "Vodka", quantity: 1.5, units: .ounces, type: .vodka),
        Ingredient(name: "Coffee Liqueur", quantity: 1, units: .ounces, type: .liqueur),
        Ingredient(name: "Fresh Brewed Espresso", quantity: 1, units: .ounces, type: .mixer),
        Ingredient(name: "Simple Syrup", quantity: 0.25, units: .ounces, type: .mixer)
    ]
    
    static var recipeSteps: [RecipeStep] = [
        RecipeStep(instruction: "Combine vodka, coffee liqueur, espresso, and simple syrup in a shaker."),
        RecipeStep(instruction: "Fill shaker with ice and shake vigorously."),
        RecipeStep(instruction: "Strain into a chilled cocktail glass."),
        RecipeStep(instruction: "Garnish with three coffee beans.")
    ]
    
    static var recipeSections: [RecipeSection] = [
        RecipeSection(title: "Preparation")
    ]
    
    static func setupRelationships() {
        recipe.ingredients = ingredients
        recipe.sections = recipeSections
        recipeSections[0].steps = recipeSteps
    }
}


struct mojito: CocktailRecipeProtocol {
    
    static var recipe: CocktailRecipe = CocktailRecipe(name: "Mojito")
    
    static var ingredients: [Ingredient] = [
        Ingredient(name: "White Rum", quantity: 2, units: .ounces, type: .rum),
        Ingredient(name: "Lime Juice", quantity: 1, units: .ounces, type: .mixer),
        Ingredient(name: "Simple Syrup", quantity: 0.5, units: .ounces, type: .mixer),
        Ingredient(name: "Mint Leaves", quantity: 10, units: .leaves, type: .garnish),
        Ingredient(name: "Soda Water", quantity: 2, units: .ounces, type: .mixer)
    ]
    
    static var recipeSteps: [RecipeStep] = [
        RecipeStep(instruction: "Muddle mint leaves with lime juice and simple syrup in a shaker."),
        RecipeStep(instruction: "Add rum and fill with ice."),
        RecipeStep(instruction: "Shake well and strain into a glass filled with ice."),
        RecipeStep(instruction: "Top with soda water."),
        RecipeStep(instruction: "Garnish with a sprig of mint and a lime wedge.")
    ]
    
    static var recipeSections: [RecipeSection] = [
        RecipeSection(title: "Mixing"),
        RecipeSection(title: "Finishing Touches")
    ]
    
    static func setupRelationships() {
        recipe.ingredients = ingredients
        recipe.sections = recipeSections
        recipeSections[0].steps = Array(recipeSteps.prefix(4))
        recipeSections[1].steps = Array(recipeSteps.suffix(1))
    }
}

struct oldFashioned: CocktailRecipeProtocol {
    
    static var recipe: CocktailRecipe = CocktailRecipe(name: "Old Fashioned")
    
    static var ingredients: [Ingredient] = [
        Ingredient(name: "Bourbon", quantity: 2, units: .ounces, type: .whiskey),
        Ingredient(name: "Sugar", quantity: 1, units: .units, type: .other),
        Ingredient(name: "Angostura Bitters", quantity: 3, units: .dashes, type: .bitters),
        Ingredient(name: "Water", quantity: 0.5, units: .ounces, type: .mixer),
        Ingredient(name: "Orange Peel", quantity: 1, units: .units, type: .garnish)
    ]
    
    static var recipeSteps: [RecipeStep] = [
        RecipeStep(instruction: "Place sugar cube in an old fashioned glass and saturate with bitters, add a dash of plain water."),
        RecipeStep(instruction: "Muddle the ingredients together until the sugar is mostly dissolved."),
        RecipeStep(instruction: "Fill the glass with large ice cubes, add bourbon."),
        RecipeStep(instruction: "Stir gently for 30 to 40 seconds."),
        RecipeStep(instruction: "Garnish with an orange twist.")
    ]
    
    static var recipeSections: [RecipeSection] = [
        RecipeSection(title: "Muddling"),
        RecipeSection(title: "Mixing"),
        RecipeSection(title: "Garnishing")
    ]
    
    static func setupRelationships() {
        recipe.ingredients = ingredients
        recipe.sections = recipeSections
        recipeSections[0].steps = [recipeSteps[0], recipeSteps[1]]
        recipeSections[1].steps = [recipeSteps[2], recipeSteps[3]]
        recipeSections[2].steps = [recipeSteps[4]]
    }
}


struct theNebula: CocktailRecipeProtocol {
    
    static var recipe: CocktailRecipe = CocktailRecipe(name: "The Nebula")
    
    static var ingredients: [Ingredient] = [
        Ingredient(name: "Blue Gin", quantity: 2, units: .ounces, type: .gin),
        Ingredient(name: "Violet Liqueur", quantity: 1, units: .ounces, type: .liqueur),
        Ingredient(name: "Lemon Juice", quantity: 1, units: .ounces, type: .mixer),
        Ingredient(name: "Tonic Water", quantity: 3, units: .ounces, type: .mixer),
        Ingredient(name: "Butterfly Pea Flower Extract", quantity: 0.5, units: .teaspoons, type: .mixer),
        Ingredient(name: "Dry Ice", quantity: 1, units: .pieces, type: .other),
        Ingredient(name: "Edible Silver Dust", quantity: 1, units: .pinches, type: .garnish)
    ]
    
    static var recipeSteps: [RecipeStep] = [
        RecipeStep(instruction: "Combine blue gin, violet liqueur, and lemon juice in a shaker with ice."),
        RecipeStep(instruction: "Shake until well chilled."),
        RecipeStep(instruction: "Strain into a glass over a small piece of dry ice for a smoky effect."),
        RecipeStep(instruction: "Slowly top with tonic water mixed with butterfly pea flower extract to create a color-changing effect."),
        RecipeStep(instruction: "Sprinkle edible silver dust over the top for a sparkling finish.")
    ]
    
    static var recipeSections: [RecipeSection] = [
        RecipeSection(title: "Mixing"),
        RecipeSection(title: "Presentation")
    ]
    
    static func setupRelationships() {
        recipe.ingredients = ingredients
        recipe.sections = recipeSections
        recipeSections[0].steps = [recipeSteps[0], recipeSteps[1]]
        recipeSections[1].steps = [recipeSteps[2], recipeSteps[3], recipeSteps[4]]
    }
}
