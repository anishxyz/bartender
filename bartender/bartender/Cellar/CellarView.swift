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
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 22).fill(.gray).opacity(0.15))
                    .padding()
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

