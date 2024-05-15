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
    var name: String
    var info: String?
    var menu: CocktailMenu?
    
    @Relationship(deleteRule: .cascade, inverse: \Ingredient.recipe) var ingredients: [Ingredient]
    @Relationship(deleteRule: .cascade, inverse: \RecipeStep.recipe) var steps: [RecipeStep]
    
    var created_at: Date
    
    init(name: String, info: String? = nil, menu: CocktailMenu? = nil, steps: [RecipeStep] = [], ingredients: [Ingredient] = []) {
        self.name = name
        self.info = info
        self.menu = menu
        self.steps = steps
        self.ingredients = ingredients
        
        self.created_at = Date()
        self.id = UUID()
    }
    
    var sortedIngredients: (_ ascending: Bool) -> [Ingredient] {
        return { ascending in
            return self.ingredients.sorted {
                ascending ? $0.created_at < $1.created_at : $0.created_at > $1.created_at
            }
        }
    }
    
    var sortedSteps: [RecipeStep] {
        return steps.sorted {
            if $0.index == $1.index {
                return $0.instruction < $1.instruction
            }
            return $0.index < $1.index
        }
    }
    
    func _reindexSteps() {
        for (newIndex, step) in steps.enumerated() {
            step.index = newIndex + 1
        }
    }
}

@Model
class Ingredient {
    @Attribute(.unique) var id: UUID
    var name: String
    var quantity: Float?
    var units: IngredientUnitType?
    var type: IngredientType
    var recipe: CocktailRecipe?
    var created_at: Date
        
    init(name: String, quantity: Float? = nil, units: IngredientUnitType?, type: IngredientType, recipe: CocktailRecipe? = nil) {
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
class RecipeStep {
    @Attribute(.unique) var id: UUID
    var index: Int
    var instruction: String
    var recipe: CocktailRecipe?
    var created_at: Date
        
    init(instruction: String, recipe: CocktailRecipe? = nil, index: Int = 0) {
        self.instruction = instruction
        self.recipe = recipe
        self.index = index
        
        self.created_at = Date()
        self.id = UUID()
    }
}


@Observable
class ObservedModel<T: PersistentModel> {
    let wrapped: T
    
    init(wrapped: T) {
        self.wrapped = wrapped
    }
}
