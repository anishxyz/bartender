//
//  CellarView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/21/23.
//

import SwiftUI


struct CellarView: View {
    @EnvironmentObject var currUser: CurrUser
    
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
        .onAppear {
            viewModel.fetchCellarData(forUserID: currUser.uid)
        }
    }
}


struct CellarView_Previews: PreviewProvider {
    static var previews: some View {

        Group {
            CellarView()
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
        }
    }
}
