//
//  PreviewContainer.swift
//  bartender
//
//  Created by Anish Agrawal on 3/24/24.
//

import SwiftData

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(
            for: Bottle.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let modelContext = container.mainContext
        if try modelContext.fetch(FetchDescriptor<Bottle>()).isEmpty {
            sampleBottles.contents.forEach { container.mainContext.insert($0) }
        }
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()
