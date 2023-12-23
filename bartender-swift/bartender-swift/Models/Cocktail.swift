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

struct Cocktail: Codable, Identifiable {
    let cocktail_id: Int
    let created_at: Date
    let updated_at: Date
    let menu_id: Int
    let name: String
    
    // Relationships
    var sections: [RecipeSection]?
    var ingredients: [Ingredient]?

    enum CodingKeys: String, CodingKey {
        case cocktail_id
        case created_at
        case updated_at
        case menu_id
        case name
    }
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
