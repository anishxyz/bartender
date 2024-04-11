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
            [SortDescriptor(\CocktailMenu.created_at, order: .reverse),
             SortDescriptor(\CocktailMenu.name)]
    ) var menus: [CocktailMenu]
    
    @Query(sort:
            [SortDescriptor(\CocktailRecipe.created_at, order: .reverse),
             SortDescriptor(\CocktailRecipe.name)]
    ) var recipes: [CocktailRecipe]
    
    var body: some View {
        Text("\(menus[0].name)")
        List {
            ForEach(recipes) { menu in
                Text("\(menu.name)")
                ForEach(menu.ingredients) { ing in
                    Text("\(ing.name)")
                }
                ForEach(menu.sections) { sect in
                    if let tit = sect.title {
                        Text("\(tit)")
                    }
                    ForEach(sect.steps) { stepp in
                        Text("\(stepp.instruction)")
                    }
                }
            }
        }        
    }
}


#Preview {
    CocktailsView()
        .modelContainer(previewContainer)
}
