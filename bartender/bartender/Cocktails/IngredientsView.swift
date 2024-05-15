//
//  IngredientsView.swift
//  bartender
//
//  Created by Anish Agrawal on 4/15/24.
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
                ForEach(ingredients) { ingredient in
                    HStack {
                        Text(ingredient.name)
                        Spacer()
                        if let quantity = ingredient.quantity {
                            Text("\(quantity, specifier: "%.01f") \(ingredient.units.rawValue)")
                                .bold()
                                .foregroundColor(.orange)
                        }
                    }
                    .padding(.vertical, 2)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.secondarySystemGroupedBackground))
            )
        }
        .padding()
    }
}
