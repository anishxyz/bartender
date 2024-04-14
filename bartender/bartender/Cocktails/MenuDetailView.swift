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
    }
}
