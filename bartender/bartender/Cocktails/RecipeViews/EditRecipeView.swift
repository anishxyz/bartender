//
//  EditRecipeView.swift
//  bartender
//
//  Created by Anish Agrawal on 5/15/24.
//

import Foundation
import SwiftUI
import SwiftData


import SwiftUI
import SwiftData

struct EditRecipeView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Bindable var recipe: CocktailRecipe
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    VStack {
                        LabeledContent {
                            TextField("Required", text: $recipe.name)
                                .multilineTextAlignment(.trailing)
                        } label: {
                            Text("Recipe Name")
                                .bold()
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.1))
                }
                
                Group {
                    Text("Ingredients")
                        .padding(.leading, 16)
                        .font(.subheadline)
                        .bold()
                    
                    VStack(alignment: .leading) {
                        Button(action: {
                            addIngredient()
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add New Ingredient")
                            }
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                        }
                        .buttonStyle(.bordered)
                        .tint(.green)
                        
                        ForEach(recipe.ingredients, id: \.id) { ingredient in
                            IngredientEditor(ingredient: $recipe.ingredients[recipe.ingredients.firstIndex(where: { $0.id == ingredient.id })!])
                        }
                        .onDelete(perform: deleteIngredient)
                        
                        
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.1))
                }
                
            }
        }
    }
    
    private func addIngredient() {
        let newIngredient = Ingredient(name: "", units: .ounces, type: .other)
        modelContext.insert(newIngredient)
        recipe.ingredients.append(newIngredient)
        
        try? modelContext.save()
    }
    
    private func deleteIngredient(at offsets: IndexSet) {
        let sortedIngredients = recipe.sortedIngredients(true)
        offsets.forEach { index in
            let ingredientToDelete = sortedIngredients[index]
            if let originalIndex = recipe.ingredients.firstIndex(where: { $0.id == ingredientToDelete.id }) {
                recipe.ingredients.remove(at: originalIndex)
            }
        }
    }
}
