//
//  Cellar.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/22/23.
//

import Foundation

struct Bottle: Codable, Identifiable {
    var id: Int
    let created_at: Date
    let last_updated: Date
    let uid: UUID
    let name: String
    let type: String
    let qty: Int
    let current: Bool
    let price: Float?
    let description: String
    let bar_id: Int?
}

struct CellarMockData {

    static let sampleBottle = Bottle(
        id: 1,
        created_at: Date(),
        last_updated: Date(),
        uid: UUID(),
        name: "Vintage Wine",
        type: "Red Wine",
        qty: 10,
        current: true,
        price: 29.99,
        description: "A fine vintage wine from 1980.",
        bar_id: 101
    )

    static let Cellar = [
        sampleBottle,
        Bottle(
            id: 2,
            created_at: Date(),
            last_updated: Date(),
            uid: UUID(),
            name: "Chardonnay",
            type: "White Wine",
            qty: 15,
            current: true,
            price: 19.99,
            description: "A popular white wine with a rich flavor.",
            bar_id: 102
        ),
        Bottle(
            id: 3,
            created_at: Date(),
            last_updated: Date(),
            uid: UUID(),
            name: "Rosé Wine",
            type: "Rosé",
            qty: 8,
            current: true,
            price: 22.50,
            description: "A refreshing rosé perfect for summer evenings.",
            bar_id: 103
        ),
        Bottle(
            id: 4,
            created_at: Date(),
            last_updated: Date(),
            uid: UUID(),
            name: "Cabernet Sauvignon",
            type: "Red Wine",
            qty: 12,
            current: false,
            price: 35.00,
            description: "A bold cabernet sauvignon with deep flavors.",
            bar_id: 104
        )
    ]
}
