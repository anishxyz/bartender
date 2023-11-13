//
//  bartenderApp.swift
//  bartender
//
//  Created by Anish Agrawal on 11/10/23.
//

import SwiftUI

@main
struct bartenderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
