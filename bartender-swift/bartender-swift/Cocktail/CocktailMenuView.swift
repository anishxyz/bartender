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
    @StateObject var loadingState = LoadingStateViewModel()
    
    @State private var showingAddMenuSheet = false
    @State private var isRefreshing = false

    
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
                        NavigationLink(destination: CocktailMenuDetailView(menu_id: menu.menu_id)) {
                            MenuCardView(menu: menu)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(2 * gridSpacing)
            }
            .navigationTitle("Menus")
            .refreshable {
                loadingState.startLoading()
                
                viewModel.fetchAllMenus(userID: currUser.uid) {
                    loadingState.stopLoading()
                }
            }

            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        ActivityIndicatorLS(loadingState: loadingState, style: .medium, color: UIColor.orange)
                        addMenuToolbarItem
                    }
                }
            }
            .sheet(isPresented: $showingAddMenuSheet) {
                AddMenuSheetView(isPresented: $showingAddMenuSheet)
                    .environmentObject(viewModel)
                    .presentationDetents([.medium])
            }
//            .onAppear {
//                viewModel.fetchAllMenus(userID: currUser.uid)
//            }
        }
    }
    
    
    private var addMenuToolbarItem: some View {
        Menu {
            Button("From Camera (coming soon)", action: {
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

