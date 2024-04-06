//
//  CellarView.swift
//  bartender
//
//  Created by Anish Agrawal on 3/21/24.
//

import SwiftUI
import SwiftData
import UIKit

struct CellarView: View {

    //swift data queries
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
    @State private var selectedBar: Bar?
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // edit...fml
    @State private var selection = Set<Bottle>()
    @State var editMode: EditMode = .inactive
    
    
    private func toggleEditMode() {
        editMode = editMode.isEditing ? .inactive : .active
    }


    var body: some View {
        NavigationStack {
            VStack {
                List(selection: $selection) {
                    
                    Section {
                        LazyVGrid(columns: columns) {
                            ForEach(bars) { bar in
                                Button(action: {
                                    print("Tapped on \(bar.name)")
                                    
                                    if selectedBar == bar {
                                        selectedBar = nil
                                    } else {
                                        selectedBar = bar
                                    }
                                }) {
                                    Text(bar.name)
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 40)
                                }
                                .buttonStyle(.bordered)
                                .tint(selectedBar == bar ? .orange : .gray)
                            }
                        }
                        
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())

                    
                    ForEach(bottles.filter { $0.bar == selectedBar || selectedBar == nil }, id: \.self) { bottle in
                        BottleItemView(bottle: bottle)
                            .swipeActions {
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    modelContext.delete(bottle)
                                }
                            }
                    }
                    
                }
                .scrollContentBackground(.hidden)
                .environment(\.editMode, $editMode)
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
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(Color.orange)
                                .font(.system(size: 22))
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: toggleEditMode) {
                            Text(editMode.isEditing ? "Done" : "Edit")
                                .bold()
                                .font(.system(size: 14))
                        }
                        .clipShape(.capsule)
                        .buttonStyle(.bordered)
                        .tint(.orange)
                    }
                }
                .sheet(isPresented: $showingAddBottleSheet, content: {
                    AddBottleView()
                        .presentationDetents([.medium])
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
            .background(Color(UIColor.systemGroupedBackground))
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

