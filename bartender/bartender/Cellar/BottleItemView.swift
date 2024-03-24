//
//  BottleItemView.swift
//  bartender
//
//  Created by Anish Agrawal on 3/24/24.
//

import Foundation
import SwiftUI

struct BottleItemView: View {
    var bottle: Bottle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(bottle.name)
                .bold()
            Text(bottle.info)
                .font(.caption)
                .lineLimit(1)
                .truncationMode(.tail)
            HStack {
                Text(bottle.type.rawValue)
                    .fontWeight(.bold)
                    .foregroundColor(bottle.type.color)
                    .tagStyle(bgc: bottle.type.color.opacity(0.2))
                Text("\(bottle.qty)")
                    .tagStyle(bgc: Color.secondary.opacity(0.1))
                if let price = bottle.price {
                    Text(String(format: "$%.2f", price))
                        .tagStyle(bgc: Color.secondary.opacity(0.1))
                }
            }
        }
        .padding(.vertical, 4)
    }
}

extension View {
    func tagStyle(bgc: Color) -> some View {
        self.padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(bgc)
            .clipShape(Capsule())
            .font(.caption)
    }
}
