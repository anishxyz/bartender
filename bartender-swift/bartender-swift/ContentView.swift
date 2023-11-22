//
//  ContentView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/15/23.
//

import SwiftUI

struct ContentView: View {
    @State var appUser: AppUser? = nil
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            backgroundColor
                .edgesIgnoringSafeArea(.all)
            if appUser != nil {
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
