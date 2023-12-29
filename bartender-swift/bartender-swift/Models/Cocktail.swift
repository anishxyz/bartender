//
//  Cocktail.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/22/23.
//

import Foundation


struct CocktailMenu: Codable {
    let menu_id: Int
    let created_at: Date
    let updated_at: Date
    let uid: UUID
    var name: String?
    
    // Relationships
    var cocktails: [Cocktail]?
}

extension CocktailMenu: Identifiable {
    var id: Int { menu_id }
}

extension CocktailMenu: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(menu_id)
    }
}

extension CocktailMenu: Equatable {
    static func ==(lhs: CocktailMenu, rhs: CocktailMenu) -> Bool {
        return lhs.menu_id == rhs.menu_id
    }
}

struct Cocktail: Codable, Identifiable {
    let cocktail_id: Int
    let created_at: Date
    let updated_at: Date
    let menu_id: Int
    let name: String
    
    // Relationships
    var sections: [RecipeSection]?
    var ingredients: [Ingredient]?
}

extension Cocktail {
    var id: Int { cocktail_id }
}


struct Ingredient: Codable {
    let ingredient_id: Int
    let cocktail_id: Int
    let created_at: Date
    let updated_at: Date
    let name: String
    var type: String?
    var quantity: Float?
    var units: String?
}

extension Ingredient: Identifiable {
    var id: Int { ingredient_id }
}

extension Ingredient: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ingredient_id)
    }
}

struct RecipeSection: Codable {
    let section_id: Int
    let cocktail_id: Int
    let created_at: Date
    let updated_at: Date
    var name: String?
    let index: Int
    
    // relations
    var steps: [RecipeStep]?
}


extension RecipeSection: Identifiable {
    var id: Int { section_id }
}

extension RecipeSection: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(section_id)
    }
}

extension RecipeSection: Equatable {
    static func ==(lhs: RecipeSection, rhs: RecipeSection) -> Bool {
        return lhs.section_id == rhs.section_id
    }
}

struct RecipeStep: Codable {
    let step_id: Int
    let section_id: Int
    let created_at: Date
    let updated_at: Date
    let index: Int
    let instruction: String
}

extension RecipeStep: Identifiable {
    var id: Int { step_id }
}

extension RecipeStep: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(step_id)
    }
}

// ingredient lists
let margaritaIngredients = [
    Ingredient(ingredient_id: 1, cocktail_id: 1, created_at: Date(), updated_at: Date(), name: "Tequila", type: "Alcohol", quantity: 2, units: "oz"),
    Ingredient(ingredient_id: 2, cocktail_id: 1, created_at: Date(), updated_at: Date(), name: "Triple Sec", type: "Alcohol", quantity: 1, units: "oz"),
    Ingredient(ingredient_id: 3, cocktail_id: 1, created_at: Date(), updated_at: Date(), name: "Lime Juice", type: "Juice", quantity: 1, units: "oz")
]

// recipe steps
let margaritaSteps = [
    RecipeStep(step_id: 1, section_id: 1, created_at: Date(), updated_at: Date(), index: 1, instruction: "Combine all ingredients in a shaker."),
    RecipeStep(step_id: 2, section_id: 1, created_at: Date(), updated_at: Date(), index: 2, instruction: "Shake well with ice."),
    RecipeStep(step_id: 3, section_id: 1, created_at: Date(), updated_at: Date(), index: 3, instruction: "Strain into a chilled glass.")
]

// recipe sections
let margaritaSection = RecipeSection(section_id: 1, cocktail_id: 1, created_at: Date(), updated_at: Date(), name: "Mixing", index: 1, steps: margaritaSteps)

// ex cocktails
let margarita = Cocktail(cocktail_id: 1, created_at: Date(), updated_at: Date(), menu_id: 1, name: "Margarita", sections: [margaritaSection], ingredients: margaritaIngredients)

// menu!
let cocktailMenu = CocktailMenu(menu_id: 1, created_at: Date(), updated_at: Date(), uid: UUID(), name: "My Cocktail Menu", cocktails: [margarita])
