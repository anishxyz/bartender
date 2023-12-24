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

    var body: some View {
        NavigationView {
            List(viewModel.menus) { menu in
                VStack(alignment: .leading) {
                    Text(menu.name ?? "Unknown Menu")
                        .font(.headline)
//                    Text("\(menu.recipes.count) recipes")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("🥂 Menus")
            .onAppear {
                viewModel.fetchAllMenus(userID: currUser.uid)
            }
        }
    }
}

struct CocktailMenuView_Previews: PreviewProvider {
    static var previews: some View {
        
        let mockViewModel = CocktailViewModel()

        CocktailMenuView()
            .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
            .environmentObject(mockViewModel)
    }
}
