//
//  CocktailRecipe.swift
//  bartender
//
//  Created by Anish Agrawal on 4/7/24.
//

import SwiftData
import Foundation


@Model
class CocktailRecipe {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String
    var info: String?
    var menu: CocktailMenu?
    
    @Relationship(deleteRule: .cascade, inverse: \Ingredient.recipe)
    var ingredients: [Ingredient]
    @Relationship(deleteRule: .cascade, inverse: \RecipeSection.recipe)
    var sections: [RecipeSection]
    
    var created_at: Date
    
    init(name: String, info: String? = nil, menu: CocktailMenu? = nil, sections: [RecipeSection] = [], ingredients: [Ingredient] = []) {
        self.name = name
        self.info = info
        self.menu = menu
        
        self.sections = sections
        self.ingredients = ingredients
        
        self.created_at = Date()
        self.id = UUID()
    }
}

@Model
class Ingredient {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String
    var quantity: Float?
    var units: IngredientUnitType
    var type: IngredientType
    var recipe: CocktailRecipe?
    
    var created_at: Date
    
    init(name: String, quantity: Float? = nil, units: IngredientUnitType, type: IngredientType, recipe: CocktailRecipe? = nil) {
        self.name = name
        self.quantity = quantity
        self.units = units
        self.type = type
        self.recipe = recipe
        
        self.created_at = Date()
        self.id = UUID()
    }
}

@Model
class RecipeSection {
    @Attribute(.unique) var id: UUID
    @Relationship(deleteRule: .cascade, inverse: \RecipeStep.section)
    var steps: [RecipeStep]
    var title: String?
    var index: Int
    var recipe: CocktailRecipe?
    
    var created_at: Date

    
    init(title: String? = nil, recipe: CocktailRecipe? = nil, steps: [RecipeStep] = [], index: Int = 0) {
        self.title = title
        self.recipe = recipe
        self.index = index
        self.steps = steps
        
        self.created_at = Date()
        self.id = UUID()
    }
    
    func addStep(_ step: RecipeStep) {
        self.steps.append(step)
        step.section = self
        _reindexSteps()
    }

    func addSteps(_ steps: [RecipeStep]) {
        self.steps.append(contentsOf: steps)
        steps.forEach { $0.section = self }
        _reindexSteps()
    }

    private func _reindexSteps() {
        for (newIndex, step) in steps.enumerated() {
            step.index = newIndex + 1
        }
    }
    
    func removeStep(withId id: UUID) {
        if let index = steps.firstIndex(where: { $0.id == id }) {
            steps.remove(at: index)
            _reindexSteps()
        }
    }

    // Alternative: Remove a step by its index in the steps array
    func removeStep(at index: Int) {
        let adjustedIndex = index - 1
        if adjustedIndex >= 0 && adjustedIndex < steps.count {
            steps.remove(at: adjustedIndex)
            _reindexSteps()
        }
    }
}


@Model
class RecipeStep {
    @Attribute(.unique) var id: UUID
    var index: Int
    var instruction: String
    var section: RecipeSection?
    
    var created_at: Date
    
    init(instruction: String, section: RecipeSection? = nil, index: Int = 0) {
        self.instruction = instruction
        self.section = section
        self.index = index
        
        self.created_at = Date()
        self.id = UUID()
    }
}


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

