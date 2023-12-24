//
//  HomeView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/16/23.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var currUser: CurrUser
    
    // view models
    @StateObject var cellarViewModel = CellarViewModel()
    @StateObject var cocktailViewModel = CocktailViewModel()
    
    var body: some View {
        TabView {
            CellarView()
                .tabItem {
                    Label("Cellar", systemImage: "wineglass.fill")
                }
            
            CocktailMenuView()
                .tabItem {
                    Label("Cocktails", systemImage: "books.vertical.fill")
                }
            
            BuilderView()
                .tabItem {
                    Label("Builder", systemImage: "flame.fill")
                }
            
            UserDataView()
                .tabItem {
                    Label("Debug", systemImage: "hammer.fill")
                }
        }
        .environmentObject(cellarViewModel)
        .environmentObject(cocktailViewModel)
        .onAppear {
            cellarViewModel.fetchCellarData(forUserID: currUser.uid)
            cocktailViewModel.fetchAllMenus(userID: currUser.uid)
        }
    }
}

struct UserDataView: View {
    @EnvironmentObject var currUser: CurrUser

    var body: some View {
        VStack {
            Text(currUser.uid)
            
            Text(currUser.email ?? "No Email")
            
            Button {
                Task {
                    do {
                        try await AuthManager.shared.signOut()
                        currUser.uid = ""
                        currUser.email = nil
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {

        Group {
            HomeView()
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
            
            HomeView()
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
                .environment(\.colorScheme, .dark)
        }
    }
}
