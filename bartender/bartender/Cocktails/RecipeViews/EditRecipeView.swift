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
                        
                        ForEach(sortedIngredients, id: \.id) { ingredient in
                            if let index = recipe.ingredients.firstIndex(where: { $0.id == ingredient.id }) {
                                HStack {
                                    IngredientEditor(ingredient: $recipe.ingredients[index])
                                    Button(action: {
                                        deleteIngredient(at: index)
                                    }) {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
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
    
    private func deleteIngredient(at index: Int) {
        let ingredientToDelete = recipe.ingredients[index]
        modelContext.delete(ingredientToDelete)
        recipe.ingredients.remove(at: index)
        
        try? modelContext.save()
    }
    
    
    // recipe step helpers
    var sortedRecipeSteps: [RecipeStep] {
        recipe.steps.sorted { $0.created_at < $1.created_at }
    }
    
    private func addRecipeStep() {
        let newIndex = (recipe.steps.map { $0.index }.max() ?? -1) + 1
        let newRecipeStep = RecipeStep(instruction: "", index: newIndex)
        modelContext.insert(newRecipeStep)
        recipe.steps.append(newRecipeStep)
        
        try? modelContext.save()
    }
}
