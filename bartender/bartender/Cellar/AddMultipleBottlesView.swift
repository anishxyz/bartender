//
//  AddMultipleBottlesView.swift
//  bartender
//
//  Created by Anish Agrawal on 3/26/24.
//

import Foundation
import SwiftUI

struct AddMultipleBottlesView: View {
    var bottles: [Bottle]

    var body: some View {
        List(bottles, id: \.name) { bottle in
            VStack(alignment: .leading) {
                Text(bottle.name)
                    .font(.headline)
                Text("Type: \(bottle.type.rawValue)")
                    .font(.subheadline)
                Text("Quantity: \(bottle.qty)")
                
                if let price = bottle.price {
                    Text("Price: $\(price, specifier: "%.2f")")
                }
                if let info = bottle.info, !info.isEmpty {
                    Text("Info: \(info)")
                }
                if let bar = bottle.bar?.name {
                    Text("Bar: \(bar)")
                }
            }
            .padding(.vertical, 4)
        }
    }
}
