//
//  CocktailsView.swift
//  bartender
//
//  Created by Anish Agrawal on 3/21/24.
//

import SwiftUI
import SwiftData

struct CocktailsView: View {
    
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
                    }
                }
                .padding()
            }
            .navigationTitle("Cocktail Menus")
            .background(Color(UIColor.systemGroupedBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            showingCreateMenuSheet = true
                        }) {
                            HStack {
                                Text("Create Menu")
                                Image(systemName: "square.and.pencil")
                            }
                        }
                        Button(action: {
                            showingUploadMenuFromImageSheet = true
                        }) {
                            HStack {
                                Text("From Image")
                                Image(systemName: "square.and.pencil")
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
}


#Preview {
    CocktailsView()
        .modelContainer(previewContainer)
}
