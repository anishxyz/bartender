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
    @Attribute(.unique) var name: String
    var info: String?
    @Relationship(deleteRule: .nullify, inverse: \Bottle.bar) var bottles: [Bottle]
    
    init(name: String, info: String? = nil, bottles: [Bottle] = []) {
        self.name = name
        self.info = info
        self.bottles = bottles
    }
}
