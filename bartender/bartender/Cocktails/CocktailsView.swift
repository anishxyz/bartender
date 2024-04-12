//
//  CocktailsView.swift
//  bartender
//
//  Created by Anish Agrawal on 3/21/24.
//

import SwiftUI
import SwiftData

struct CocktailsView: View {
    
    @Query(sort:
            [SortDescriptor(\CocktailMenu.created_at),
             SortDescriptor(\CocktailMenu.name)]
    ) var menus: [CocktailMenu]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
        
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(menus, id: \.id) { menu in
                        NavigationLink(destination: MenuDetailView(menu: menu)) {
                            MenuItemView(menu: menu)
                        }
                        .buttonStyle(.bordered)
                        .tint(.orange)
                    }
                }
                .padding()
            }
            .navigationTitle("Cocktail Menus")
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}


#Preview {
    CocktailsView()
        .modelContainer(previewContainer)
}


struct MenuDetailView: View {
    var menu: CocktailMenu
    
    var body: some View {
        List {
            ForEach(menu.recipes) { recipe in
                Text(recipe.name)
            }
        }
        .navigationTitle(menu.name)
        .background(Color(UIColor.systemGroupedBackground))
    }
}
