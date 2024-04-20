//
//  IngredientTypePicker.swift
//  bartender
//
//  Created by Anish Agrawal on 4/19/24.
//

import Foundation
import SwiftUI

struct IngredientTypePicker: View {
    @Binding var selectedType: IngredientType
    let options: [IngredientType] = IngredientType.allCases

    var body: some View {
        Menu {
            ForEach(options, id: \.self) { option in
                Button(action: {
                    self.selectedType = option
                }) {
                    HStack {
                        Text(option.rawValue.capitalized)
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
                    Text(selectedType.rawValue.capitalized)
                    Image(systemName: "chevron.up.chevron.down")
                }
            }
            .buttonStyle(.bordered)
            .tint(.orange)
        }
    }
}

#Preview {
    IngredientTypePicker(selectedType: .constant(.garnish))
}
