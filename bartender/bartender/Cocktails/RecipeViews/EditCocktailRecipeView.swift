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
    
    @Bindable var recipe: CocktailRecipe
    
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
                    Button(action: {
                    
                        let newIngredient = Ingredient(name: "", units: .ounces, type: .other)
                        recipe.ingredients.append(newIngredient)
                        
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
                    
                    ForEach(Array(recipe.ingredients.enumerated()), id: \.element.id) { index, ingredient in
                        IngredientEditor(ingredient: $recipe.ingredients[index])
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

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: CocktailMenu.self, configurations: config)
    
    spicyMargarita.setupRelationships()
    
    container.mainContext.insert(spicyMargarita.recipe)
    

    return EditCocktailRecipeView(recipe: spicyMargarita.recipe)
        .modelContainer(container)
}
