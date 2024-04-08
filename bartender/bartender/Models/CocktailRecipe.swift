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
    var updated_at: Date
    
    init(name: String, info: String? = nil, menu: CocktailMenu? = nil, sections: [RecipeSection] = [], ingredients: [Ingredient] = []) {
        self.name = name
        self.info = info
        self.menu = menu
        
        self.sections = sections
        self.ingredients = ingredients
        
        self.created_at = Date()
        self.updated_at = Date()
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
    var recipe: CocktailRecipe
    
    var created_at: Date
    var updated_at: Date
    
    init(name: String, quantity: Float? = nil, units: IngredientUnitType, type: IngredientType, recipe: CocktailRecipe) {
        self.name = name
        self.quantity = quantity
        self.units = units
        self.type = type
        self.recipe = recipe
        
        self.created_at = Date()
        self.updated_at = Date()
        self.id = UUID()
    }
}

@Model
class RecipeSection {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var title: String?
    @Attribute(.unique) var index: Int
    @Relationship(deleteRule: .cascade, inverse: \RecipeStep.section)
    var steps: [RecipeStep]
    var recipe: CocktailRecipe
    
    var created_at: Date
    var updated_at: Date

    
    init(title: String? = nil, recipe: CocktailRecipe, steps: [RecipeStep] = []) {
        self.title = title
        self.recipe = recipe
        self.index = recipe.sections.count + 1
        self.steps = steps
        
        self.created_at = Date()
        self.updated_at = Date()
        self.id = UUID()
    }
}


@Model
class RecipeStep {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var instruction: String
    @Attribute(.unique) var index: Int
    var section: RecipeSection
    
    var created_at: Date
    var updated_at: Date
    
    init(instruction: String, section: RecipeSection) {
        self.instruction = instruction
        self.section = section
        self.index = section.steps.count + 1
        
        self.created_at = Date()
        self.updated_at = Date()
        self.id = UUID()
    }
}

class sampleRecipes {
    
    var spicyMargarita: CocktailRecipe
    var newYorkSour: CocktailRecipe
    var theGoldenHour: CocktailRecipe
    var recipes: [CocktailRecipe]
    
    init() {
        
        // Initialize spicyMargarita recipe
        spicyMargarita = CocktailRecipe(name: "Spicy Margarita")
        
        // Initialize ingredients
        let tequila = Ingredient(name: "Tequila", quantity: 2, units: .ounces, type: .tequila, recipe: spicyMargarita)
        let limeJuice = Ingredient(name: "Lime Juice", quantity: 1, units: .ounces, type: .mixer, recipe: spicyMargarita)
        let agaveSyrup = Ingredient(name: "Agave Syrup", quantity: 0.5, units: .ounces, type: .mixer, recipe: spicyMargarita)
        let jalapeno = Ingredient(name: "Jalapeno", quantity: 3, units: .slices, type: .garnish, recipe: spicyMargarita)
        
        // Initialize sections and steps
        let preparationSection = RecipeSection(recipe: spicyMargarita)
        let preparationSteps = [
            RecipeStep(instruction: "Muddle the jalapeno slices in the shaker.", section: preparationSection),
            RecipeStep(instruction: "Add tequila, lime juice, and agave syrup to shaker with ice.", section: preparationSection),
            RecipeStep(instruction: "Shake well.", section: preparationSection),
            RecipeStep(instruction: "Strain into a chilled glass.", section: preparationSection)
        ]

        // Assemble
        spicyMargarita.ingredients.append(contentsOf: [tequila, limeJuice, agaveSyrup, jalapeno])
        spicyMargarita.sections.append(preparationSection)
        preparationSection.steps.append(contentsOf: preparationSteps)
        
        
        // Initialize newYorkSour recipe
        newYorkSour = CocktailRecipe(name: "New York Sour")
                
        // Ingredients
        let whiskey = Ingredient(name: "Whiskey", quantity: 2, units: .ounces, type: .whiskey, recipe: newYorkSour)
        let lemonJuice = Ingredient(name: "Lemon Juice", quantity: 1, units: .ounces, type: .mixer, recipe: newYorkSour)
        let simpleSyrup = Ingredient(name: "Simple Syrup", quantity: 0.5, units: .ounces, type: .mixer, recipe: newYorkSour)
        let redWine = Ingredient(name: "Red Wine", quantity: 0.5, units: .ounces, type: .mixer, recipe: newYorkSour)
        
        newYorkSour.ingredients.append(contentsOf: [whiskey, lemonJuice, simpleSyrup, redWine])

        // Sections and Steps
        let mixingSection = RecipeSection(title: "Mixing", recipe: newYorkSour)
        mixingSection.steps.append(contentsOf: [
            RecipeStep(instruction: "Combine whiskey, lemon juice, and simple syrup in a shaker.", section: mixingSection),
            RecipeStep(instruction: "Fill the shaker with ice and shake until well chilled.", section: mixingSection),
            RecipeStep(instruction: "Strain into a rocks glass filled with fresh ice.", section: mixingSection)
        ])

        let finishingTouchesSection = RecipeSection(title: "Finishing Touches", recipe: newYorkSour)
        finishingTouchesSection.steps.append(contentsOf: [
            RecipeStep(instruction: "Gently pour red wine over the back of a spoon so it floats on top of the drink.", section: finishingTouchesSection)
        ])

        newYorkSour.sections.append(contentsOf: [mixingSection, finishingTouchesSection])
        
        // Initialize theGoldenHour recipe
        theGoldenHour = CocktailRecipe(name: "The Golden Hour")
                
        // Ingredients
        let agedRum = Ingredient(name: "Aged Rum", quantity: 2, units: .ounces, type: .rum, recipe: theGoldenHour)
        let saffronSyrup = Ingredient(name: "Saffron-Infused Simple Syrup", quantity: 0.75, units: .ounces, type: .mixer, recipe: theGoldenHour)
        let champagne = Ingredient(name: "Champagne", quantity: 1, units: .ounces, type: .mixer, recipe: theGoldenHour)
        let lemonJuice2 = Ingredient(name: "Lemon Juice", quantity: 0.5, units: .ounces, type: .mixer, recipe: theGoldenHour)
        let eggWhite = Ingredient(name: "Egg White", quantity: 1, units: .eggs, type: .other, recipe: theGoldenHour)
        let goldLeaf = Ingredient(name: "Edible Gold Leaf", quantity: 1, units: .leaves, type: .garnish, recipe: theGoldenHour)
        
        theGoldenHour.ingredients.append(contentsOf: [agedRum, saffronSyrup, champagne, lemonJuice2, eggWhite, goldLeaf])

        // Preparation Sections
        let mixingSection2 = RecipeSection(title: "Mixing", recipe: theGoldenHour)
        mixingSection2.steps.append(contentsOf: [
            RecipeStep(instruction: "In a shaker, combine aged rum, saffron-infused simple syrup, lemon juice, and egg white.", section: mixingSection2),
            RecipeStep(instruction: "Dry shake (without ice) vigorously for 30 seconds to emulsify the egg white.", section: mixingSection2),
            RecipeStep(instruction: "Add ice to the shaker and shake again until well chilled.", section: mixingSection2),
            RecipeStep(instruction: "Strain into a coupe glass.", section: mixingSection2)
        ])
        
        let finishingTouchesSection2 = RecipeSection(title: "Finishing Touches", recipe: theGoldenHour)
        finishingTouchesSection2.steps.append(contentsOf: [
            RecipeStep(instruction: "Top with champagne.", section: finishingTouchesSection2),
            RecipeStep(instruction: "Carefully place an edible gold leaf on the foam for garnish.", section: finishingTouchesSection2)
        ])
        
        theGoldenHour.sections.append(contentsOf: [mixingSection2, finishingTouchesSection2])
        

        // Initialize the recipes array with both cocktails
        recipes = [spicyMargarita, newYorkSour, theGoldenHour]
    }
    
    
}

