//
//  PreviewContainer.swift
//  bartender
//
//  Created by Anish Agrawal on 3/24/24.
//

import SwiftData
import Foundation

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Bottle.self, Bar.self, CocktailMenu.self, CocktailRecipe.self, Ingredient.self, RecipeSection.self, RecipeStep.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let modelContext = container.mainContext
        
        if try modelContext.fetch(FetchDescriptor<Bottle>()).isEmpty {
            sampleBottles.contents.forEach { container.mainContext.insert($0) }
        }
        
        if try modelContext.fetch(FetchDescriptor<Bar>()).isEmpty {
            sampleBars.contents.forEach { container.mainContext.insert($0) }
        }
        
        
        let bottles = sampleBottles.contents
        let bars = sampleBars.contents

        let totalBottles = bottles.count
        let firstBarBottlesCount = totalBottles / 3
        let secondBarBottlesCount = totalBottles / 2
        let lastBarBottlesCount = totalBottles - firstBarBottlesCount - secondBarBottlesCount

        if bars.count >= 3 {
            sampleBars.contents[bars.count - 1].bottles = Array(bottles[0..<firstBarBottlesCount])
            sampleBars.contents[bars.count - 2].bottles = Array(bottles[firstBarBottlesCount..<(firstBarBottlesCount + secondBarBottlesCount)])
            sampleBars.contents[bars.count - 3].bottles = Array(bottles[(firstBarBottlesCount + secondBarBottlesCount)...])
        }
        
        
        if try modelContext.fetch(FetchDescriptor<CocktailMenu>()).isEmpty {
            sampleCocktailMenu.setupRelationships()
            
            container.mainContext.insert(sampleCocktailMenu.menu)
            container.mainContext.insert(sampleCocktailMenu.menu2)
        }
        
        
        if try modelContext.fetch(FetchDescriptor<CocktailRecipe>()).isEmpty {
            spicyMargarita.setupRelationships()
            newYorkSour.setupRelationships()
            goldenHour.setupRelationships()
            
            container.mainContext.insert(spicyMargarita.recipe)
            container.mainContext.insert(newYorkSour.recipe)
            container.mainContext.insert(goldenHour.recipe)
        }
       
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

