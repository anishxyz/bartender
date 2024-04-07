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
    @State private var showingEditBarSheet = false
    @State private var selectedBar: Bar?
    
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // edit...fml
    @State private var selection = Set<Bottle>()
    @State var editMode: EditMode = .inactive
    @State private var searchText = ""
    
    private func toggleEditMode() {
        editMode = editMode.isEditing ? .inactive : .active
    }

    var filteredBottles: [Bottle] {
        if searchText.isEmpty {
            return bottles
        } else {
            return bottles.filter { bot in
                bot.name.localizedCaseInsensitiveContains(searchText) ||
                bot.type.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            List(selection: $selection) {
                if !bars.isEmpty {
                    Section {
                        LazyVGrid(columns: columns) {
                            ForEach(bars) { bar in
                                Button(action: {
                                    if editMode == .inactive {
                                        if selectedBar == bar {
                                            selectedBar = nil
                                        } else {
                                            selectedBar = bar
                                        }
                                    } else {
                                        for bottle in selection {
                                            bottle.bar = bar
                                        }
                                        toggleEditMode()
                                        try? modelContext.save()
                                    }
                                }) {
                                    Text(bar.name)
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 40)
                                }
                                .buttonStyle(.bordered)
                                .tint(selectedBar == bar ? .orange : .blue)
                            }
                        }
                        
                    }
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets())
                }

                
                ForEach(filteredBottles.filter { $0.bar == selectedBar || selectedBar == nil }, id: \.self) { bottle in
                    BottleItemView(bottle: bottle)
                        .swipeActions {
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                modelContext.delete(bottle)
                            }
                        }
                }
                .searchable(text: $searchText)
                
            }
            .background(Color(UIColor.systemGroupedBackground))
            .scrollContentBackground(.hidden)
            .environment(\.editMode, $editMode)
            .navigationTitle("🍷 Cellar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        BottleToolbarSection(
                            showingAddBottleSheet: $showingAddBottleSheet,
                            showingAddBottleFromImageSheet: $showingAddBottleFromImageSheet
                        )
                        BarToolbarSection(showingAddBarSheet: $showingAddBarSheet)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.orange)
                            .font(.system(size: 22))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    CellarEditToolbarButton(
                        editMode: $editMode,
                        showingEditBarSheet: $showingEditBarSheet,
                        toggleEditMode: toggleEditMode
                    )                    
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
            .sheet(isPresented: $showingEditBarSheet, content: {
                EditBarsView(bars: bars)
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

