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
                ForEach(recipe.sections) { section in
                    if let title = section.title {
                        Text(title)
                    }
                }
            }
        }
        .navigationTitle(recipe.name)
        .background(Color(UIColor.systemGroupedBackground))
    }
}
