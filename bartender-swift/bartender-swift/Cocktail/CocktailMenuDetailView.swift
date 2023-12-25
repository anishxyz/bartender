//
//  CocktailMenuDetailView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/25/23.
//

import SwiftUI

struct CocktailMenuDetailView: View {
    var menu: CocktailMenu?
    
    var body: some View {
        VStack {
            if let menu = menu, let cocktails = menu.cocktails {
                Text("Menu: \(menu.name ?? "Unknown")")
                    .font(.title)

                List(cocktails) { cocktail in
                    // Display each cocktail
                    Text(cocktail.name)
                }
            } else {
                Text("No details available")
            }
        }
        .navigationTitle("Cocktails")
        .navigationBarTitleDisplayMode(.inline)
    }
}

