//
//  HomeView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/16/23.
//

import SwiftUI

struct HomeView: View {
    @Binding var appUser: AppUser?
    
    var body: some View {
        if let appUser = appUser {
            TabView {
                CellarView(appUser: $appUser)
                    .tabItem {
                        Label("Cellar", systemImage: "wineglass.fill")
                    }
                
                CocktailView(appUser: $appUser)
                    .tabItem {
                        Label("Cocktails", systemImage: "books.vertical.fill")
                    }
                
                BuilderView(appUser: $appUser)
                    .tabItem {
                        Label("Builder", systemImage: "flame.fill")
                    }
                
                UserDataView(appUser: $appUser)
                    .tabItem {
                        Label("Debug", systemImage: "hammer.fill")
                    }
            }
        }
    }
}

struct UserDataView: View {
    @Binding var appUser: AppUser?

    var body: some View {
        if let appUser = appUser {
            VStack {
                Text(appUser.uid)
                
                Text(appUser.email ?? "No Email")
                
                Button {
                    Task {
                        do {
                            try await AuthManager.shared.signOut()
                            self.appUser = nil
                        } catch {
                            print("unable to sign out")
                        }
                    }
                } label: {
                    Text("Sign Out")
                        .foregroundColor(.red)
                        .buttonStyle(.bordered)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {

        Group {
            HomeView(appUser: .constant(.init(uid: "123456789", email: "anishagrawal2003@gmail.com")))
            
            HomeView(appUser: .constant(.init(uid: "123456789", email: "anishagrawal2003@gmail.com")))
                .environment(\.colorScheme, .dark)
        }
    }
}
