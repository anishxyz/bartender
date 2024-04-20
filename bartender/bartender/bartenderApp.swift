//
//  bartenderApp.swift
//  bartender
//
//  Created by Anish Agrawal on 3/21/24.
//

import SwiftUI
import SwiftData

@main
struct bartenderApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Bottle.self,
            Bar.self,
            CocktailMenu.self,
            CocktailRecipe.self,
            Ingredient.self,
            RecipeStep.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Bottle.self, Bar.self, CocktailMenu.self, CocktailRecipe.self, Ingredient.self, RecipeStep.self])
    }
}
