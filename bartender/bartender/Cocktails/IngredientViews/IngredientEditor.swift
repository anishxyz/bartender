//
//  IngredientEditorView.swift
//  bartender
//
//  Created by Anish Agrawal on 5/15/24.
//

import Foundation
import SwiftUI

struct IngredientEditor: View {
    @Binding var ingredient: Ingredient
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                TextField("Name", text: $ingredient.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                IngredientTypePicker(selectedType: $ingredient.type)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            HStack {
                TextField("Quantity", value: $ingredient.quantity, format: .number)
                    .keyboardType(.decimalPad)
                    .frame(maxWidth: .infinity, alignment: .leading)
                IngredientUnitTypePicker(selectedType: $ingredient.units)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
    }
}
