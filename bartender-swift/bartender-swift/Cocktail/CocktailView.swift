//
//  CocktailView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/21/23.
//

import SwiftUI


struct CocktailView: View {
    @EnvironmentObject var currUser: CurrUser
    
    var body: some View {
        Text("Cocktail View")
    }
}


struct CocktailView_Previews: PreviewProvider {
    static var previews: some View {

        Group {
            CocktailView()
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
        }
    }
}

