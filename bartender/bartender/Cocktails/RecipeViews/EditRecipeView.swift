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
                                Text("Add Ingredient")
                            }
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                        }
                        .buttonStyle(.bordered)
                        .tint(.green)
                        
                        ForEach(sortedIngredients) { ingredient in
                            if let index = recipe.ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                                IngredientEditor(ingredient: $recipe.ingredients[index])
                            }
                        }
                        
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.1))
                }
                
                Group {
                    Text("Recipe Step")
                        .padding(.leading, 16)
                        .font(.subheadline)
                        .bold()
                    
                    VStack(alignment: .leading) {
                        Button(action: {
                            addRecipeStep()
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Recipe Step")
                            }
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                        }
                        .buttonStyle(.bordered)
                        .tint(.green)
                        
                        ForEach(sortedRecipeSteps) { step in
                            if let index = recipe.steps.firstIndex(where: { $0.id == step.id }) {
                                RecipeStepEditor(step: $recipe.steps[index])
                            }
                        }
                        
                        
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.1))
                }
                
            }
        }
    }
    
    // ingredient helpers
    var sortedIngredients: [Ingredient] {
        recipe.ingredients.sorted { $0.created_at < $1.created_at }
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
    
    
    // recipe step helpers
    var sortedRecipeSteps: [RecipeStep] {
        recipe.steps.sorted { $0.created_at < $1.created_at }
    }
    
    private func addRecipeStep() {
        let newRecipeStep = RecipeStep(instruction: "", index: 0)
        modelContext.insert(newRecipeStep)
        recipe.steps.append(newRecipeStep)
        
        try? modelContext.save()
    }
}
