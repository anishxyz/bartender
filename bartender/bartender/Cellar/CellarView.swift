//
//  CellarView.swift
//  bartender
//
//  Created by Anish Agrawal on 3/21/24.
//

import SwiftUI
import SwiftData

struct CellarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query var bottles: [Bottle]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(bottles) { bottle in
                    BottleItemView(bottle: bottle)
                }
            }
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
