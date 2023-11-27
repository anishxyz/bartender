//
//  Cellar.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/21/23.
//

import SwiftUI


struct CellarView: View {
    @Binding var appUser: AppUser?
    
    @StateObject var viewModel = CellarViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack {
                List(viewModel.cellar) { bottle in
                    VStack {
                        Text(bottle.name)
                        Text(bottle.type)
                    }
                }
                .navigationTitle("🍾 The Cellar")
            }
        }
    }
}


struct CellarView_Previews: PreviewProvider {
    static var previews: some View {

        Group {
            CellarView(appUser: .constant(.init(uid: "123456789", email: "anishagrawal2003@gmail.com")))
        }
    }
}
