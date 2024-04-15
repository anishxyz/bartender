//
//  VersionedSchemas.swift
//  bartender
//
//  Created by Anish Agrawal on 3/25/24.
//

import Foundation
import SwiftData

//enum BartenderSchemaV1: VersionedSchema {
//    
//    static var models: [any PersistentModel.Type] {
//        [Bottle.self, Bar.self]
//    }
//    
//    @Model
//    final class Bottle {
//        var name: String
//        var type: BottleType
//        var qty: Int
//        var price: Float?
//        var info: String?
//        var bar: Bar?
//        
//        init(name: String, type: BottleType, qty: Int, price: Float? = nil, info: String?, bar: Bar? = nil) {
//            self.name = name
//            self.type = type
//            self.qty = qty
//            self.price = price
//            self.info = info
//            self.bar = bar
//        }
//    }
//    
//    @Model
//    final class Bar {
//        var name: String
//        var info: String?
//        @Relationship(deleteRule: .nullify, inverse: \Bottle.bar) var bottles: [Bottle]
//        
//        init(name: String, info: String? = nil, bottles: [Bottle] = []) {
//            self.name = name
//            self.info = info
//            self.bottles = bottles
//        }
//    }
//}
//
//
//enum BartenderSchemaV2: VersionedSchema {
//    static var models: [any PersistentModel.Type] {
//        [Bottle.self, Bar.self]
//    }
//    
//    @Model
//    final class Bottle {
//        @Attribute(.unique) var name: String
//        var type: BottleType
//        var qty: Int
//        var price: Float?
//        var info: String?
//        var bar: Bar?
//        
//        init(name: String, type: BottleType, qty: Int, price: Float? = nil, info: String?, bar: Bar? = nil) {
//            self.name = name
//            self.type = type
//            self.qty = qty
//            self.price = price
//            self.info = info
//            self.bar = bar
//        }
//    }
//    
//    @Model
//    final class Bar {
//        var name: String
//        var info: String?
//        @Relationship(deleteRule: .nullify, inverse: \Bottle.bar) var bottles: [Bottle]
//        
//        init(name: String, info: String? = nil, bottles: [Bottle] = []) {
//            self.name = name
//            self.info = info
//            self.bottles = bottles
//        }
//    }
//}
