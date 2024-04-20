//
//  EditCocktailRecipeView.swift
//  bartender
//
//  Created by Anish Agrawal on 4/17/24.
//

import SwiftUI
import SwiftData

struct EditCocktailRecipeView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Binding var recipe: CocktailRecipe

    
    var body: some View {
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
                    Button {
                        let newIngredient = Ingredient(name: "", units: .ounces, type: .other, recipe: recipe)
                        modelContext.insert(newIngredient)
                        recipe.ingredients.append(newIngredient)
                    } label: {
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
                    
                    ForEach(Array($recipe.ingredients.enumerated()), id: \.element.id) { index, $ingredient in
                        IngredientEditor(ingredient: $ingredient)
                        if index < recipe.ingredients.count - 1 {
                            Divider()
                        }
                    }
                    .onDelete { indices in
                        indices.forEach { index in
                            recipe.ingredients.remove(at: index)
                        }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.1))
            }
            
            Group {
                VStack(alignment: .leading) {
                    Text("Notes")
                        .bold()
                    TextField("Optional", text: Binding<String>(
                        get: { recipe.info ?? "" },
                        set: { recipe.info = $0.isEmpty ? nil : $0 }
                    ), axis: .vertical)
                    .lineLimit(6)
                }
                
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.1))
            
        }
    }
}


struct IngredientEditor: View {
    @Binding var ingredient: Ingredient
    
    private let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0 // Minimum decimal places
        formatter.maximumFractionDigits = 2 // Maximum decimal places
        return formatter
    }()
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                TextField("Name", text: $ingredient.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                IngredientTypePicker(selectedType: $ingredient.type)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            HStack {
                TextField("Quantity", value: $ingredient.quantity, formatter: decimalFormatter)
                    .keyboardType(.decimalPad)
                    .frame(maxWidth: .infinity, alignment: .leading)
                IngredientUnitTypePicker(selectedType: $ingredient.units)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: CocktailMenu.self, configurations: config)
    
    spicyMargarita.setupRelationships()
    
    container.mainContext.insert(spicyMargarita.recipe)
    

    return EditCocktailRecipeView(recipe: .constant(spicyMargarita.recipe))
        .modelContainer(container)
}
