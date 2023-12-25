//
//  CocktailView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/21/23.
//

import SwiftUI

struct CocktailMenuView: View {
    @EnvironmentObject var currUser: CurrUser
    @EnvironmentObject var viewModel: CocktailViewModel
    
    @State private var showingAddMenuSheet = false
    
    let gridSpacing: CGFloat = 10
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: gridSpacing) {
                    ForEach(viewModel.menus) { menu in
                        NavigationLink(destination: CocktailMenuDetailView(menu: menu)) {
                            MenuCardView(menu: menu)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(2 * gridSpacing)
            }
            .navigationTitle("🥂 Menus")
            .refreshable {
                viewModel.fetchAllMenus(userID: currUser.uid)

            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addMenuToolbarItem
                }
            }
            .sheet(isPresented: $showingAddMenuSheet) {
                AddMenuSheetView(isPresented: $showingAddMenuSheet)
                    .environmentObject(viewModel)
                    .presentationDetents([.medium])
            }
            .onAppear {
                viewModel.fetchAllMenus(userID: currUser.uid)
            }
            
        }
    }
    
    
    private var addMenuToolbarItem: some View {
        Menu {
            Button("From Camera", action: {
                // Action for selecting 'From Camera'
            })
            Button("Enter Manually", action: {
                showingAddMenuSheet = true
            })
        } label: {
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.orange)
                .colorMultiply(.orange)
        }
    }
}


struct CocktailMenuView_Previews: PreviewProvider {
    static var previews: some View {
        
        let mockViewModel = CocktailViewModel()

        Group {
            CocktailMenuView()
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
                .environmentObject(mockViewModel)
            
            CocktailMenuView()
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
                .environmentObject(mockViewModel)
                .environment(\.colorScheme, .dark)
        }
    }
}
