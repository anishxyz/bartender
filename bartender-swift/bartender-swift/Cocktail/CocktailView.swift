//
//  CocktailView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/21/23.
//

import SwiftUI


struct CocktailView: View {
    @Binding var appUser: AppUser?
    
    var body: some View {
        Text("Cocktail View")
    }
}


struct CocktailView_Previews: PreviewProvider {
    static var previews: some View {

        Group {
            CocktailView(appUser: .constant(.init(uid: "123456789", email: "anishagrawal2003@gmail.com")))
        }
    }
}

