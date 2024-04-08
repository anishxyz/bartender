//
//  CocktailMenu.swift
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
    @Relationship(deleteRule: .nullify, inverse: \CocktailRecipe.menu)
    var recipes: [CocktailRecipe]
    var info: String?
    
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
