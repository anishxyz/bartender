//
//  RecipeDetailView.swift
//  bartender
//
//  Created by Anish Agrawal on 4/14/24.
//

import Foundation
import SwiftUI


struct RecipeDetailView: View {
    var recipe: CocktailRecipe
    
    var body: some View {
        ScrollView {
            VStack {
                IngredientsView(ingredients: recipe.ingredients)
                
                // TODO: solve cascading increase issue
                ForEach(recipe.sortedSections, id: \.id) { section in
                    RecipeSectionView(section: section)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .navigationTitle(recipe.name)
        .background(Color(UIColor.systemGroupedBackground))
    }
}
