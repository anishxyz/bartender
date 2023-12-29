//
//  CocktailDetailView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/28/23.
//

import SwiftUI

struct CocktailDetailView: View {
    let menuId: Int
    let cocktailId: Int
    @EnvironmentObject var viewModel: CocktailViewModel
    
    var cocktail: Cocktail? {
        let cocktailDetail = viewModel.menus.first { $0.menu_id == menuId }?
            .cocktails?.first { $0.cocktail_id == cocktailId }
        return cocktailDetail
    }
    
    
    var body: some View {
        ScrollView {
            if let cocktail = cocktail {
                VStack(alignment: .leading) {
                    
                    // Ingredients Section
                    if let ingredients = cocktail.ingredients {
                        IngredientsView(ingredients: ingredients)
                    }
                    
                    // Recipe Sections
                    ForEach(cocktail.sections ?? [], id: \.self) { section in
                        RecipeSectionView(section: section)
                    }
                }
            } else {
                Text("Cocktail not found.")
            }
        }
        .navigationTitle(cocktail?.name ?? "Cocktail Details")
        .navigationBarTitleDisplayMode(.inline)

    }
}


struct CocktailDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let mockViewModel = CocktailViewModel()
        
        let currUser = CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com")

        Group {
            CocktailDetailView(menuId: 14, cocktailId: 290)
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
                .environmentObject(mockViewModel)
                .onAppear {
                    mockViewModel.fetchAllMenus(userID: currUser.uid)
                }
            
            CocktailDetailView(menuId: 14, cocktailId: 290)
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
                .environmentObject(mockViewModel)
                .environment(\.colorScheme, .dark)
                .onAppear {
                    mockViewModel.fetchAllMenus(userID: currUser.uid)
                }
        }
    }
}
