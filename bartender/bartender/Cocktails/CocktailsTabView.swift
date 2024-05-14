//
//  CocktailsView.swift
//  bartender
//
//  Created by Anish Agrawal on 3/21/24.
//

import SwiftUI
import SwiftData

struct CocktailsTabView: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query(sort:
            [SortDescriptor(\CocktailMenu.created_at),
             SortDescriptor(\CocktailMenu.name)]
    ) var menus: [CocktailMenu]
    
    // toolbar
    @State private var showingCreateMenuSheet = false
    @State private var showingUploadMenuFromImageSheet = false
    
    let columns = [
        GridItem(.flexible(), spacing: 14),
        GridItem(.flexible(), spacing: 14)
    ]
        
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 14) {
                    ForEach(menus, id: \.id) { menu in
                        NavigationLink(destination: MenuDetailView(menu: menu)) {
                            MenuItemView(menu: menu)
                        }
                        .buttonStyle(.bordered)
                        .tint(.orange)
                        .contextMenu {
                            contextMenu(for: menu)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Cocktail Menus")
            .background(Color(UIColor.systemGroupedBackground))
            .toolbar {
                toolbarContent
            }
            .sheet(isPresented: $showingCreateMenuSheet, content: {
                CreateMenuView()
                    .presentationDetents([.medium])
                
            })
            .sheet(isPresented: $showingUploadMenuFromImageSheet, content: {
                CreateMenuFromImageView{ bottles in
                    print(bottles)
                }
                    .presentationDetents([.medium])
                
            })
        }
    }
    
    private func contextMenu(for menu: CocktailMenu) -> some View {
        Group {
            Button(role: .destructive) {
                modelContext.delete(menu)
                try? modelContext.save()
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .navigationBarTrailing) {
            Menu {
                Button(action: {
                    showingCreateMenuSheet = true
                }) {
                    HStack {
                        Text("Add Manually")
                        Image(systemName: "square.and.pencil")
                    }
                }
                Button(action: {
                    showingUploadMenuFromImageSheet = true
                }) {
                    HStack {
                        Text("From Image")
                        Image(systemName: "photo")
                    }
                }
            } label: {
                Image(systemName: "plus.circle.fill")
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.orange)
                    .font(.system(size: 22))
            }
        }
    }
}


#Preview {
    CocktailsTabView()
        .modelContainer(previewContainer)
}
