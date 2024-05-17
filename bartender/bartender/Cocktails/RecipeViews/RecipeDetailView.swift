//
//  RecipeDetailView.swift
//  bartender
//
//  Created by Anish Agrawal on 4/14/24.
//

import Foundation
import SwiftUI


struct RecipeDetailView: View {
    @State var recipe: CocktailRecipe
    
    var body: some View {
        ScrollView {
            VStack {
                IngredientsView(ingredients: recipe.ingredients)
                RecipeStepsView(steps: recipe.steps)
            }
        }
        .navigationTitle(recipe.name)
        .background(Color(UIColor.systemGroupedBackground))
    }
}
