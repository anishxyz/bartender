//
//  IngredientUnitTypePicker.swift
//  bartender
//
//  Created by Anish Agrawal on 4/20/24.
//

import Foundation
import SwiftUI

struct IngredientUnitTypePicker: View {
    @Binding var selectedType: IngredientUnitType?
    let options: [IngredientUnitType?] = [nil] + IngredientUnitType.allCases

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    self.selectedType = option
                }) {
                    HStack {
                        Text(option?.rawValue ?? "None")
                        if selectedType == option {
                            Spacer()
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
        } label: {
            Button(action: {}) {
                HStack {
                    Text(selectedType?.rawValue ?? "None")
                    Image(systemName: "chevron.up.chevron.down")
                }
            }
            .buttonStyle(.bordered)
            .tint(.orange)
        }
    }
}

#Preview {
    IngredientUnitTypePicker(selectedType: .constant(.ounces))
}
