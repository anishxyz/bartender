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
                Text("Space")
                    .padding(.top, 30)
                ForEach($bottles.indices, id: \.self) { index in
                    EditBottleView(bottle: $bottles[index])
                        .padding()
                        .padding(.horizontal)
                }
            }
        }
    }
}
