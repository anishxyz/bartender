//
//  BottleDetailView.swift
//  bartender
//
//  Created by Anish Agrawal on 5/19/24.
//

import SwiftUI
import UIKit

struct BottleDetailView: View {
    
    var bottle: Bottle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(bottle.name)
                .bold()
                .font(.title)
            if let info = bottle.info {
                Text(info)
            }
            VStack(spacing: 8) {
                HStack {
                    Text("Type:")
                    Spacer()
                    HStack {
                        Image(bottle.type.filledSymbolName)
                        Text(bottle.type.rawValue)
                            .lineLimit(1)
                    }
                    .tagStyle(bgc: bottle.type.color)
                }
                HStack {
                    Text("Quantity:")
                    Spacer()
                    Text("\(bottle.qty)")
                        .tagStyle(bgc: Color.secondary)
                        .lineLimit(1)
                }
                HStack {
                    Text("Bar:")
                    Spacer()
                    if let bar = bottle.bar {
                        Text("\(bar.name)")
                            .tagStyle(bgc: .blue)
                            .lineLimit(1)
                    }
                }
                HStack {
                    Text("Price:")
                    Spacer()
                    if let price = bottle.price {
                        Text(String(format: "$%.2f", price))
                            .tagStyle(bgc: Color.secondary)
                            .lineLimit(1)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemGroupedBackground))
            )
            Spacer()
        }
        .padding()
    }
}
