//
//  CellarView.swift
//  bartender
//
//  Created by Anish Agrawal on 3/21/24.
//

import SwiftUI
import SwiftData

struct CellarView: View {
    
    //swift data
    @Environment(\.modelContext) private var modelContext
    @Query(sort:
            [SortDescriptor(\Bottle.created_at, order: .reverse),
             SortDescriptor(\Bottle.name)]
    ) var bottles: [Bottle]
    @Query(sort:
            [SortDescriptor(\Bar.created_at, order: .reverse),
             SortDescriptor(\Bar.name)]
    ) var bars: [Bar]
    
    // bottles
    @State private var showingAddBottleSheet = false
    @State private var showingAddBottleFromImageSheet = false
    
    // bars
    @State private var showingAddBarSheet = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(bottles) { bottle in
                    BottleItemView(bottle: bottle)
                        .swipeActions {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                modelContext.delete(bottle)
                            }
                        }
                }
            }
            .navigationTitle("🍾 Cellar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Section(header: Text("Bottle").font(.headline)) {
                            Button(action: {
                                showingAddBottleSheet = true
                            }) {
                                HStack {
                                    Text("Add Manually")
                                    Image(systemName: "square.and.pencil")
                                }
                            }
                            Button(action: {
                                showingAddBottleFromImageSheet = true
                            }) {
                                HStack {
                                    Text("From Image")
                                    Image(systemName: "photo")
                                }
                            }
                        }
                        Section(header: Text("Bar").font(.headline)) {
                            Button(action: {
                                showingAddBarSheet = true
                            }) {
                                HStack {
                                    Text("Create Bar")
                                    Image("cellar.three.bottles.fill")
                                }
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
            .sheet(isPresented: $showingAddBarSheet, content: {
                AddBarView()
                    .presentationDetents([.medium])
                
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

