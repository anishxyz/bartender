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
    @State private var showingDeleteConfirmation = false
    @State private var selectedMenuID: Int?
    
    let gridSpacing: CGFloat = 10
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    // image stuff
    @State private var showCameraPicker = false
    @State private var showPhotoLibraryPicker = false
    @State private var selectedImage: UIImage?
    
    func processSelectedImage(_ image: UIImage) {
        // Convert UIImage to Data
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            loadingState.startLoading()
            viewModel.createCocktailMenu(fromImage: imageData, base64Image: nil, userID: currUser.uid) {
                loadingState.stopLoading()
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: gridSpacing) {
                    ForEach(viewModel.menus) { menu in
                        NavigationLink(destination: CocktailMenuDetailView(menu_id: menu.menu_id)) {
                            MenuCardView(menu: menu)
                                .contextMenu {
                                    MenuContextMenuView(menuID: menu.menu_id, showingDeleteConfirmation: $showingDeleteConfirmation, selectedMenuID: $selectedMenuID)
                                }
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
            .sheet(isPresented: $showCameraPicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
                    .onDisappear {
                        if let selectedImage = selectedImage {
                            processSelectedImage(selectedImage)
                        }
                    }
            }
            .sheet(isPresented: $showPhotoLibraryPicker) {
                ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
                    .onDisappear {
                        if let selectedImage = selectedImage {
                            processSelectedImage(selectedImage)
                        }
                    }
            }
            .alert("Are you sure you want to delete this menu?", isPresented: $showingDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    if let menuID = selectedMenuID {
                        loadingState.startLoading()
                        
                        viewModel.deleteMenu(menuID: menuID, userID: currUser.uid) {
                            loadingState.stopLoading()
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
//            .onAppear {
//                viewModel.fetchAllMenus(userID: currUser.uid)
//            }
        }
    }
    
    struct MenuContextMenuView: View {
        let menuID: Int
        @Binding var showingDeleteConfirmation: Bool
        @Binding var selectedMenuID: Int?

        var body: some View {
            Button(action: {
                selectedMenuID = menuID
                showingDeleteConfirmation = true
            }) {
                HStack {
                    Text("Delete Menu")
                    Image(systemName: "trash")
                }
                .foregroundColor(.red)
            }
        }
    }
    
    
    private var addMenuToolbarItem: some View {
        Menu {
            Section(header: Text("Create Menu").font(.headline)) {
                Button("From Camera", action: {
                    self.showCameraPicker = true
                })
                Button("From Photo Library", action: {
                    self.showPhotoLibraryPicker = true
                })
                Button("Enter Manually", action: {
                    showingAddMenuSheet = true
                })
            }
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
        
        let currUser = CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com")

        Group {
            CocktailMenuView()
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
                .environmentObject(mockViewModel)
                .onAppear {
                    mockViewModel.fetchAllMenus(userID: currUser.uid)
                }
            
            CocktailMenuView()
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
                .environmentObject(mockViewModel)
                .environment(\.colorScheme, .dark)
                .onAppear {
                    mockViewModel.fetchAllMenus(userID: currUser.uid)
                }
        }
    }
}

