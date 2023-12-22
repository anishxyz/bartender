//
//  BottleDetailView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/28/23.
//

import SwiftUI

struct BottleDetailView: View {
    let bottle: Bottle

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(bottle.name)
                .font(.headline)
                .bold()

            Text(bottle.description)
                .font(.subheadline)
                .foregroundColor(.gray)

            HStack {
                let bottleType = BottleType(rawValue: bottle.type) ?? .other
                TypeTag(type: bottleType)
                
                Spacer()
                
                if let price = bottle.price {
                    Text("Price: $\(price, specifier: "%.2f")")
                        .font(.footnote)
                }
                
                Text("Qty: \(bottle.qty)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct TypeTag: View {
    let type: BottleType

    var body: some View {
        Text(type.rawValue)
            .font(.caption)
            .fontWeight(.bold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(type.color) // Use color from BottleType
            .foregroundColor(.white)
            .cornerRadius(8)
    }
}

struct BottleDetailView_Previews: PreviewProvider {
    static var previews: some View {

        Group {
            BottleDetailView(bottle: CellarMockData.sampleBottle)
                .environmentObject(CurrUser(uid: "8E2FC51E-58A6-469D-B932-D483DD9E10B5", email: "anishagrawal2003@gmail.com"))
        }
    }
}
