//
//  AddBarView.swift
//  bartender
//
//  Created by Anish Agrawal on 4/1/24.
//

import Foundation
import SwiftUI

struct AddBarView: View {
    
    @State private var barName: String = ""
    @State private var barInfo: String = ""
    
    var body: some View {
        VStack {
            LabeledContent {
                TextField("Required", text: $barName)
                    .multilineTextAlignment(.trailing)
            } label: {
                Text("Name")
                    .bold()
            }
            Divider()
            VStack(alignment: .leading) {
                Text("Notes")
                    .bold()
                TextField("Optional", text: $barInfo, axis: .vertical)
                .lineLimit(6)
            }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.1))
    }
}


#Preview {
    AddBarView()
}
