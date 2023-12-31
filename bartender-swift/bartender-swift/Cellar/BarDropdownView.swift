//
//  BarDropdown.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/31/23.
//

import SwiftUI

struct BarDropdownView: View {
    var bars: [Bar]
    var onSelect: (Bar?) -> Void
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: CellarViewModel

    var body: some View {
        HStack {
            Menu {
                Button("Full Cellar", action: {
                    onSelect(nil)
                })
                .textCase(nil)
                Divider()
                ForEach(bars, id: \.bar_id) { bar in
                    Button(bar.name, action: {
                        onSelect(bar)
                    })
                        .textCase(nil)
                }
            } label: {
                HStack {
                    Text("Bars")
                        .bold()
                    Image(systemName: "chevron.down") // System icon for the caret
                }
                .textCase(nil)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .background(Color.orange.colorMultiply(.orange))
                .clipShape(Capsule())
            }
            Spacer()
        }
        .padding(.leading, -18) // This value may need to be adjusted based on the default List padding
        .padding(.bottom, 10)
    }
}
