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
