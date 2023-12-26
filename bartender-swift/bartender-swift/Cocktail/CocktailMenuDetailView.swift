//
//  CocktailMenuDetailView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/25/23.
//

import SwiftUI

struct CocktailMenuDetailView: View {
    var menu: CocktailMenu?
    @Environment(\.colorScheme) var colorScheme // To detect the current color scheme

    var body: some View {
        VStack {
            if let menu = menu, let cocktails = menu.cocktails {
                List(cocktails) { cocktail in
                    Text(cocktail.name)
                        
                }
            } else {
                Text("No details available")
            }
        }
        .background(colorScheme == .light ? Color.white : Color.clear)
        .navigationTitle("Cocktails")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("From Camera", action: {
                        // Action for selecting 'From Camera'
                    })
                    Button("Build Cocktail", action: {
                        // cocktail builder manual
                    })
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.orange)
                        .colorMultiply(.orange)
                }
            }
        }
    }
}


struct CocktailMenuDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            CocktailMenuDetailView(menu: cocktailMenu)
            
            CocktailMenuDetailView(menu: cocktailMenu)
                .environment(\.colorScheme, .dark)
        }
    }
}
