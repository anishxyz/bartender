//
//  CreateCocktailRecipeView.swift
//  bartender
//
//  Created by Anish Agrawal on 4/19/24.
//

import Foundation
import SwiftUI
import SwiftData

struct CreateRecipeView: View {
    // env
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @Binding var menu: CocktailMenu
    @State var recipe: CocktailRecipe = CocktailRecipe(name: "")
    
    var body: some View {
        VStack {
            EditRecipeView(recipe: recipe)
            
            Button {
                modelContext.insert(recipe)
                menu.recipes.append(recipe)
                try? modelContext.save()
                dismiss()
            } label: {
                Text("Save")
                    .bold()
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
            }
            .buttonStyle(.bordered)
            .tint(.green)
        }
        .padding(12)
        .background(RoundedRectangle(cornerRadius: 22).fill(.gray).opacity(0.15))
        .padding()
        
        Spacer()
    }
}

//#Preview {
//    let config = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = try! ModelContainer(for: CocktailMenu.self, configurations: config)
//    
//    sampleCocktailMenu.setupRelationships()
//    
//    container.mainContext.insert(sampleCocktailMenu.menu)
//    
//    @State var sampleMenu = sampleCocktailMenu.menu
//
//    return CreateCocktailRecipeView(menu: $sampleMenu)
//        .modelContainer(container)
//}

