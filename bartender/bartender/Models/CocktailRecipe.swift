//
//  CocktailRecipe.swift
//  bartender
//
//  Created by Anish Agrawal on 4/7/24.
//

import SwiftData
import Foundation

@Model
class CocktailMenu {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String
    var info: String?
    
    @Relationship(deleteRule: .nullify, inverse: \CocktailRecipe.menu)
    var recipes: [CocktailRecipe]
    var created_at: Date
    var updated_at: Date
    
    init(name: String, info: String? = nil, recipes: [CocktailRecipe] = []) {
        self.name = name
        self.info = info
        self.recipes = recipes
        
        self.created_at = Date()
        self.updated_at = Date()
        self.id = UUID()
    }
    
}

@Model
class CocktailRecipe {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String
    var info: String?
    var menu: CocktailMenu?
    var created_at: Date
    var updated_at: Date
    
    @Relationship(deleteRule: .cascade, inverse: \Ingredient.recipe)
    var ingredients: [Ingredient]
    @Relationship(deleteRule: .cascade, inverse: \RecipeSection.recipe)
    var sections: [RecipeSection]
    
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
    
    var recipe: CocktailRecipe
    
    var created_at: Date
    var updated_at: Date
    
    var steps: [RecipeStep]?
    
    init() {
        
        
        self.created_at = Date()
        self.updated_at = Date()
        self.id = UUID()
    }
}


@Model
class RecipeStep {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String
    @Attribute(.unique) var index: Int
    
    var recipe: CocktailRecipe
    
    var created_at: Date
    var updated_at: Date
    
    var steps: [RecipeStep]?
}
