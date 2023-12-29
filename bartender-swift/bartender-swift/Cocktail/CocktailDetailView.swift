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
                        VStack(alignment: .leading) {
                            if let sectionName = section.name {
                                Text(sectionName)
                                    .font(.subheadline)
                                    .bold()
                                    .padding(.bottom, 5)
                            }
                            
                            ForEach(section.steps ?? [], id: \.self) { step in
                                HStack {
                                    Text("\(step.index).")
                                    Text(step.instruction)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                        .padding()
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


struct IngredientsView: View {
    var ingredients: [Ingredient]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Ingredients")
                .font(.subheadline)
                .bold()
                .padding(.bottom, 5)
            
            VStack {
                ForEach(ingredients, id: \.self) { ingredient in
                    HStack {
                        Text(ingredient.name)
                        Spacer()
                        Group {
                            if let quantity = ingredient.quantity, quantity > 0 {
                                Text("\(String(format: "%.1f", quantity))")
                            }
                            Text(ingredient.units ?? "")
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemGray6))
            )
        }
        .padding()
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
