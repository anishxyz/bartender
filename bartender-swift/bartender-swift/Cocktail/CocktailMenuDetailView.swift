//
//  CocktailMenuDetailView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/25/23.
//

import SwiftUI

struct CocktailMenuDetailView: View {
    let menu_id: Int
    
    @EnvironmentObject var viewModel: CocktailViewModel
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var currUser: CurrUser
    
    @State private var showImagePicker = false
    @State private var imagePickerSourceType = UIImagePickerController.SourceType.photoLibrary
    @State private var selectedImage: UIImage?
    
    var menu: CocktailMenu? {
        viewModel.menus.first { $0.menu_id == menu_id }
    }

    var body: some View {
        VStack {
            if let menu = menu, let cocktails = menu.cocktails, !cocktails.isEmpty {
                List(cocktails) { cocktail in
                    NavigationLink(destination: CocktailDetailView(menuId: menu_id, cocktailId: cocktail.cocktail_id)) {
                        Text(cocktail.name)
                    }
                }
            } else {
                Text("No cocktails here! Add one with the +")
            }
        }
        .background(colorScheme == .light ? Color.white : Color.clear)
        .navigationTitle("Cocktails")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button("From Camera", action: {
                        self.imagePickerSourceType = .camera
                        self.showImagePicker = true
                    })
                    Button("From Photo Library", action: {
                        self.imagePickerSourceType = .photoLibrary
                        self.showImagePicker = true
                    })
                    Button("Build Cocktail (coming soon)", action: {
                        // cocktail builder manual
                    })
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.orange)
                        .colorMultiply(.orange)
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: imagePickerSourceType)
                .onDisappear {
                    if let selectedImage = selectedImage {
                        processSelectedImage(selectedImage)
                    }
                }
        }
    }
    
    func processSelectedImage(_ image: UIImage) {
        // Convert UIImage to Data
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            
            guard let menuID = menu?.menu_id else { return }

            // Call the function to create cocktails for the menu
            viewModel.createCocktailsForMenu(fromImage: imageData, base64Image: nil, menuID: menuID, userID: currUser.uid)
        }
    }
}


struct CocktailMenuDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let mockViewModel = CocktailViewModel()
        
        let currUser = CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com")

        Group {
            CocktailMenuDetailView(menu_id: 14)
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
                .environmentObject(mockViewModel)
                .onAppear {
                    mockViewModel.fetchAllMenus(userID: currUser.uid)
                }
            
            CocktailMenuDetailView(menu_id: 14)
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
                .environmentObject(mockViewModel)
                .environment(\.colorScheme, .dark)
                .onAppear {
                    mockViewModel.fetchAllMenus(userID: currUser.uid)
                }
        }
    }
}
