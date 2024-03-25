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
            CellarView()
                .tabItem {
                    Label("Cellar", image: "cellar.six.bottles.fill")
                }
            CocktailsView()
                .tabItem {
                    Label("Sent", systemImage: "tray.and.arrow.up.fill")
                }
        }
    }

}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
