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
    
    @State private var isAuthenticating = true
    
    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            
            if isAuthenticating {
                // Display a loading or intermediate view while checking authentication
                LoadingView()
            } else {
                if appUser != nil {
                    HomeView()
                        .environmentObject(currUser)
                } else {
                    SignInView(appUser: $appUser)
                        .environmentObject(currUser)
                }
            }
        }
        .onAppear {
            Task {
                do {
                    let sessionUser = try await AuthManager.shared.getCurrentSession()
                    self.appUser = sessionUser
                    self.currUser.uid = sessionUser.uid
                    self.currUser.email = sessionUser.email
                } catch {
                    // TODO: Handle errors
                }
                isAuthenticating = false
            }
        }
    }
    
    private var backgroundColor: Color {
            colorScheme == .dark ? Color.black : Color.white
        }
}


struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("OrangeLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.bottom, 50)
            ProgressView()
            Spacer()
            Text("Anish Agrawal")
        }
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
