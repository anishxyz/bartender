//
//  CreateCocktailRecipeView.swift
//  bartender
//
//  Created by Anish Agrawal on 4/19/24.
//

import Foundation
import SwiftUI
import SwiftData

struct CreateCocktailRecipeView: View {
    // env
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State var recipe: CocktailRecipe = CocktailRecipe(name: "")
    
    var body: some View {
        VStack {
            EditCocktailRecipeView(recipe: $recipe)
            
            Button {
                modelContext.insert(recipe)
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

#Preview {
    CreateCocktailRecipeView()
}
