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
    var units: String?
    var type: IngredientType
    var recipe: CocktailRecipe
    
    var created_at: Date
    var updated_at: Date
    
    init(name: String, quantity: Float? = nil, units: String? = nil, type: IngredientType, recipe: CocktailRecipe) {
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
    @Attribute(.unique) var name: String
    @Attribute(.unique) var index: Int
    @Relationship(deleteRule: .cascade, inverse: \RecipeStep.section)
    var steps: [RecipeStep]
    var recipe: CocktailRecipe
    
    var created_at: Date
    var updated_at: Date

    
    init(name: String, recipe: CocktailRecipe, steps: [RecipeStep] = []) {
        self.name = name
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

