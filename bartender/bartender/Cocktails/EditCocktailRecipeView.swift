//
//  EditCocktailRecipeView.swift
//  bartender
//
//  Created by Anish Agrawal on 4/17/24.
//

import SwiftUI

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
                        MenuPicker(selectedMenu: $recipe.menu)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.1))
            }

            Group {
                ForEach($recipe.sections) { $section in // TODO: sorted
                    SectionView(section: $section)
                }

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

struct SectionView: View {
    @Binding var section: RecipeSection
    
    var body: some View {
        VStack {
            Text(section.title ?? "Section")
                .bold()
            ForEach(section.sortedSteps) { step in
                Text(step.instruction)
            }
        }
    }
}

struct MenuPicker: View {
    @Binding var selectedMenu: CocktailMenu?
    
    var body: some View {
        Picker("Select Menu", selection: $selectedMenu) {
//            ForEach(CocktailMenu.allMenus, id: \.self) { menu in
//                Text(menu.name).tag(menu as CocktailMenu?)
//            }
        }
    }
}


#Preview {
    EditCocktailRecipeView(recipe: $spicyMargarita.recipe)
        .modelContainer(previewContainer)
}
