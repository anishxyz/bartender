//
//  EditCocktailRecipeView.swift
//  bartender
//
//  Created by Anish Agrawal on 4/17/24.
//

import SwiftUI
import SwiftData

struct EditCocktailRecipeView: View {
    @Binding var recipe: CocktailRecipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                VStack {
                    LabeledContent {
                        TextField("Required", text: $recipe.name)
                            .multilineTextAlignment(.trailing)
                    } label: {
                        Text("Recipe Name")
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("Menu").bold()
                        Spacer()
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.1))
            }
            
            Group {
                
                VStack(alignment: .leading) {
                    Text("Description")
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
    

    return EditCocktailRecipeView(recipe: .constant(spicyMargarita.recipe))
        .modelContainer(container)
}
