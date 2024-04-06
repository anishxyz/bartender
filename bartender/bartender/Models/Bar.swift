//
//  Bar.swift
//  bartender
//
//  Created by Anish Agrawal on 3/24/24.
//

import Foundation
import SwiftData

@Model
class Bar {
    @Attribute(.unique) var id: UUID
    @Attribute(.unique) var name: String
    var info: String?
    var created_at: Date
    var updated_at: Date
    
    @Relationship(deleteRule: .nullify, inverse: \Bottle.bar)
    var bottles: [Bottle]
    
    init(name: String, info: String? = nil, bottles: [Bottle] = []) {
        self.name = name
        self.info = info
        self.bottles = bottles
        self.created_at = Date()
        self.updated_at = Date()
        self.id = UUID()
    }
}


struct sampleBars {
    static var contents: [Bar] = [
        Bar(name: "Sunset Lounge", info: "A cozy place with a great view of the sunset."),
        Bar(name: "The Oak", info: "Vintage vibes and a selection of fine whiskey."),
        Bar(name: "Ruby Room", info: "Modern cocktails and live music."),
        Bar(name: "The Cave", info: "An underground bar with a unique stone decor."),
        Bar(name: "Blue Parrot", info: "Tropical drinks and a vibrant atmosphere."),
        Bar(name: "Jazz Corner", info: "Smooth jazz and a relaxed setting."),
    ]
}
