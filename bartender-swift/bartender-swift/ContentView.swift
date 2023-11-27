//
//  ContentView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/15/23.
//

import SwiftUI

class CurrUser: ObservableObject {
    @Published var uid: String
    @Published var email: String?

    init(uid: String, email: String?) {
        self.uid = uid
        self.email = email
    }
}


struct ContentView: View {
    @State var appUser: AppUser? = nil
    @StateObject var currUser = CurrUser(uid: "", email: nil)
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            if appUser != nil {
                HomeView()
                    .environmentObject(currUser)
            } else {
                SignInView(appUser: $appUser)
            }
        }
        .onAppear {
            Task {
                let sessionUser = try await AuthManager.shared.getCurrentSession()
                self.appUser = sessionUser
                self.currUser.uid = sessionUser.uid
                self.currUser.email = sessionUser.email
            }
        }
    }
    
    private var backgroundColor: Color {
            colorScheme == .dark ? Color.black : Color.white
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            
            ContentView()
                .environment(\.colorScheme, .dark)
        }
    }
}
