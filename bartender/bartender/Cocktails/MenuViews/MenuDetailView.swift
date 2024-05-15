//
//  MenuDetailView.swift
//  bartender
//
//  Created by Anish Agrawal on 4/14/24.
//

import Foundation
import SwiftUI
import SwiftData


struct MenuDetailView: View {
    @State var menu: CocktailMenu
        
    // toolbar
    @State private var showingCreateCocktailRecipeSheet = false
    
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
                            Text("Create cocktail")
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
            CreateCocktailRecipeView(menu: $menu)
                .presentationDetents([.medium])
            
        })
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: CocktailMenu.self, configurations: config)
    
    sampleCocktailMenu.setupRelationships()
    
    container.mainContext.insert(sampleCocktailMenu.menu)

    return MenuDetailView(menu: sampleCocktailMenu.menu)
        .modelContainer(container)
}
