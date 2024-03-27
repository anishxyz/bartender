//
//  BottleTypePicker.swift
//  bartender
//
//  Created by Anish Agrawal on 3/27/24.
//

import SwiftUI

struct BottleTypePicker: View {
    @Binding var selectedType: BottleType
    let options: [BottleType] = BottleType.allCases

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
