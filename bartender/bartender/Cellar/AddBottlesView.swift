//
//  AddMultipleBottlesView.swift
//  bartender
//
//  Created by Anish Agrawal on 3/26/24.
//

import Foundation
import SwiftUI

struct AddBottlesView: View {
    @State var bottles: [Bottle]

    var body: some View {
        ScrollView {
            VStack {
                Text("Toolbar HERE")
                    .padding(.top, 30)
                ForEach($bottles.indices, id: \.self) { index in
                    EditBottleView(bottle: $bottles[index])
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 22).fill(.gray).opacity(0.15))
                        .padding(.vertical, 6)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    AddBottlesView(bottles: sampleBottles.contents)
}
