//
//  CellarView.swift
//  bartender
//
//  Created by Anish Agrawal on 3/21/24.
//

import SwiftUI
import SwiftData
import UIKit

struct CellarTabView: View {

    //swift data queries
    @Environment(\.modelContext) private var modelContext

    @Query(sort: [
        SortDescriptor(\Bottle.created_at, order: .reverse),
        SortDescriptor(\Bottle.name)
    ]) var bottles: [Bottle]
    
    @Query(sort: [
        SortDescriptor(\Bar.created_at),
        SortDescriptor(\Bar.name)
    ]) var bars: [Bar]
    
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
    
    // selection
    @State private var showingBottleDetailSheet = false
    @State private var selectedBottle: Bottle? = nil
    
    private func toggleEditMode() {
        editMode = editMode.isEditing ? .inactive : .active
    }

    var filteredBottles: [Bottle] {
        if searchText.isEmpty {
            return bottles
        } else {
            return bottles.filter { bot in
                bot.name.localizedCaseInsensitiveContains(searchText) ||
                bot.type.rawValue.localizedCaseInsensitiveContains(searchText) ||
                (bot.info?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    var shouldShowBottleDetailSheet: Bool {
        showingBottleDetailSheet && selectedBottle != nil
    }
    
    private var barSection: some View {
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

    var body: some View {
        NavigationStack {
            List(selection: $selection) {
                if !bars.isEmpty {
                    barSection
                }

                
                ForEach(filteredBottles.filter { $0.bar == selectedBar || selectedBar == nil }, id: \.self) { bottle in
                    Button(action: {
                        self.selectedBottle = bottle
                        self.showingBottleDetailSheet = true
                    }) {
                        BottleItemView(bottle: bottle)
                    }
                    .foregroundColor(.primary)
                    .swipeActions {
                        Button(role: .destructive) {
                            modelContext.delete(bottle)
                            try? modelContext.save()
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let bottle = filteredBottles[index]
                        modelContext.delete(bottle)
                    }
                    try? modelContext.save()
                }
            }
            .searchable(text: $searchText)
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
            .sheet(isPresented: Binding<Bool>(
                get: { shouldShowBottleDetailSheet },
                set: { if !$0 { selectedBottle = nil } }
            )) {
                if let bottle = selectedBottle {
                    BottleDetailView(bottle: Binding(
                        get: { bottle },
                        set: { self.selectedBottle = $0 }
                    ))
                        .presentationDetents([.medium, .large])
                } else {
                    Text("Error viewing bottle: \(selectedBottle?.name ?? "None")")
                        .presentationDetents([.medium])
                }
            }
//            // SQL LITE DB CONNECTION COMMAND
//            .onAppear {
//                print(modelContext.sqliteCommand)
//            }
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

