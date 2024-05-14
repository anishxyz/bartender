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
    var name: String
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

struct sampleCocktailMenu {
    
    static var menu: CocktailMenu = CocktailMenu(name: "Anish's Cocktails")
    static var menu2: CocktailMenu = CocktailMenu(name: "Part Two")
    
    static func setupRelationships() {
        spicyMargarita.setupRelationships()
        newYorkSour.setupRelationships()
        goldenHour.setupRelationships()
        
        menu.recipes = [
            spicyMargarita.recipe,
            newYorkSour.recipe,
            goldenHour.recipe
        ]
        
        espressoMartini.setupRelationships()
        mojito.setupRelationships()
        oldFashioned.setupRelationships()
        theNebula.setupRelationships()
        
        menu2.recipes = [
            espressoMartini.recipe,
            mojito.recipe,
            oldFashioned.recipe,
            theNebula.recipe
        ]
    }
}
