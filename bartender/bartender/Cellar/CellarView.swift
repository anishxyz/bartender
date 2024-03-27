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
    
    @State private var showingAddBottleSheet = false
    @State private var showingAddBottleFromImageSheet = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(bottles) { bottle in
                    BottleItemView(bottle: bottle)
                }
            }
            .navigationTitle("🍾 Cellar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Section(header: Text("Bottle").font(.headline)) {
                            Button("Add Bottle") {
                                showingAddBottleSheet = true
                            }
                            Button("Add Bottle from Image") {
                                showingAddBottleFromImageSheet = true
                            }
                        }
                        Section(header: Text("Bar").font(.headline)) {
                            Button("Add Bar") {
                                // TODO: Add bar functionality
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.orange)
                            .colorMultiply(.orange)
                    }
                }
            }
            .sheet(isPresented: $showingAddBottleSheet, content: {
                AddBottleView()
            })
            .sheet(isPresented: $showingAddBottleFromImageSheet, content: {
                BottleUploadViewHandler()
                    .presentationDetents([.medium, .large])
                
            })
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(previewContainer)
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
        .preferredColorScheme(.dark)
}

