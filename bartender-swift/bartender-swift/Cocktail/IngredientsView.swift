//
//  IngredientsView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/29/23.
//

import SwiftUI

struct IngredientsView: View {
    var ingredients: [Ingredient]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Ingredients")
                .font(.subheadline)
                .bold()
                .padding(.bottom, 5)
            
            VStack {
                ForEach(ingredients, id: \.self) { ingredient in
                    HStack {
                        Text(ingredient.name)
                        Spacer()
                        Group {
                            if let quantity = ingredient.quantity, quantity > 0 {
                                Text("\(String(format: "%.1f", quantity))")
                                    .bold()
                            }
                            Text(ingredient.units ?? "")
                                .bold()
                        }
                        .foregroundColor(.orange)
                        .colorMultiply(.orange)
                    }
                    .padding(.vertical, 2)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemGray6))
            )
        }
        .padding()
    }
}
