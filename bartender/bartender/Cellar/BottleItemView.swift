//
//  BottleItemView.swift
//  bartender
//
//  Created by Anish Agrawal on 3/24/24.
//

import Foundation
import SwiftUI

struct BottleItemView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var bottle: Bottle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(bottle.name)
                .bold()
            if let info = bottle.info {
                Text(info)
                    .font(.caption)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }
            HStack {
                HStack {
                    Image(bottle.type.filledSymbolName)
                    Text(bottle.type.rawValue)
                }
                    .tagStyle(bgc: bottle.type.color)
                if let bar = bottle.bar {
                    Text("\(bar.name)")
                        .tagStyle(bgc: .blue)
                        .lineLimit(1)
                }
                Text("\(bottle.qty)")
                    .tagStyle(bgc: Color.secondary)
                    .lineLimit(1)
                if let price = bottle.price {
                    Text(String(format: "$%.2f", price))
                        .tagStyle(bgc: Color.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

extension View {
    
    func tagStyle(bgc: Color) -> some View {
        self.fontWeight(.bold)
            .foregroundColor(bgc.opacity(0.85))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(bgc.opacity(0.2))
            .clipShape(Capsule())
            .font(.caption)
    }
}

#Preview {
    BottleItemView(bottle: exampleBottle)
}

#Preview {
    BottleItemView(bottle: exampleBottle)
        .preferredColorScheme(.dark)
}
