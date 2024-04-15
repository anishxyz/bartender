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
    
    var sortedSections: [RecipeSection] {
        return sections.sorted {
            if $0.index == $1.index {
                return ($0.title ?? "") < ($1.title ?? "")
            }
            return $0.index < $1.index
        }
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
        
    init(name: String, quantity: Float? = nil, units: IngredientUnitType, type: IngredientType, recipe: CocktailRecipe? = nil) {
        self.name = name
        self.quantity = quantity
        self.units = units
        self.type = type
        self.recipe = recipe
        
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
    
    
    init(title: String? = nil, recipe: CocktailRecipe? = nil, steps: [RecipeStep] = [], index: Int = 0) {
        self.title = title
        self.recipe = recipe
        self.index = index
        self.steps = steps
        
        self.id = UUID()
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
class RecipeStep {
    @Attribute(.unique) var id: UUID
    var index: Int
    var instruction: String
    var section: RecipeSection?
        
    init(instruction: String, section: RecipeSection? = nil, index: Int = 0) {
        self.instruction = instruction
        self.section = section
        self.index = index
        
        self.id = UUID()
    }
}
