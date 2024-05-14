//
//  ContentView.swift
//  bartender
//
//  Created by Anish Agrawal on 3/21/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
        
    var body: some View {
        TabView {
            CellarTabView()
                .tabItem {
                    Label("Cellar", image: "cellar.six.bottles.fill")
                }
            CocktailsTabView()
                .tabItem {
                    Label("Cocktails", image: "cocktail.menu.fold.fill")
                }
            BartenderView()
                .tabItem {
                    Label("Bartender", image: "case.bartender.boston3.fill")
                }
        }
    }

}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
