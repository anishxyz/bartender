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
                    VStack(alignment: .leading) {
                        Text("Ingredients")
                            .font(.title2)
                            .padding(.bottom, 5)
                        
                        ForEach(cocktail.ingredients ?? [], id: \.self) { ingredient in
                            HStack {
                                Text(ingredient.name)
                                if let type = ingredient.type {
                                    Text("Type: \(type.rawValue)")
                                        .font(.subheadline)
                                        .foregroundColor(type.color)
                                }
                                Spacer()
                                Text("\(ingredient.quantity ?? 0) \(ingredient.units ?? "")")
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .padding()
                    
                    // Recipe Sections
                    ForEach(cocktail.sections ?? [], id: \.self) { section in
                        VStack(alignment: .leading) {
                            if let sectionName = section.name {
                                Text(sectionName)
                                    .font(.title2)
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
