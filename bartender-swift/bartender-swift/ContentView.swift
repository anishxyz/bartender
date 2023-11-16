//
//  ContentView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/15/23.
//

import SwiftUI

struct ContentView: View {
    @State var appUser: AppUser? = nil
    
    var body: some View {
        ZStack {
            if let appUser = appUser {
                HomeView(appUser: $appUser)
            } else {
                SignInView(appUser: $appUser)
            }
        }
        .onAppear {
            Task {
                self.appUser = try await AuthManager.shared.getCurrentSession()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
