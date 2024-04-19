//
//  MenuDetailView.swift
//  bartender
//
//  Created by Anish Agrawal on 4/14/24.
//

import Foundation
import SwiftUI


struct MenuDetailView: View {
    var menu: CocktailMenu
    
    // toolbar
    @State private var showingCreateCocktailRecipeSheet = false
    @State private var newRecipe = CocktailRecipe(name: "")
    
    var body: some View {
        List {
            ForEach(menu.recipes) { recipe in
                NavigationLink(destination: RecipeDetailView(recipe: recipe)) {
                    Text(recipe.name)
                }
            }
        }
        .navigationTitle(menu.name)
        .background(Color(UIColor.systemGroupedBackground))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        showingCreateCocktailRecipeSheet = true
                    }) {
                        HStack {
                            Text("Create Menu")
                            Image(systemName: "square.and.pencil")
                        }
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.orange)
                        .font(.system(size: 22))
                }
            }
        }
        .sheet(isPresented: $showingCreateCocktailRecipeSheet, content: {
            EditCocktailRecipeView(recipe: $newRecipe)
                .presentationDetents([.medium])
            
        })
    }
}
