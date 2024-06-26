//
//  AddBottleView.swift
//  bartender
//
//  Created by Anish Agrawal on 3/24/24.
//

import SwiftUI

struct AddBottleView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var bottle: Bottle = Bottle(name: "", type: .wine, qty: 1)


    var body: some View {
        NavigationStack {
            VStack {
                EditBottleView(bottle: $bottle)

                Button {
                    modelContext.insert(bottle)
                    dismiss()
                } label: {
                    Text("Save")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                }
                .buttonStyle(.bordered)
                .tint(.green)
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 22).fill(.gray).opacity(0.15))
            .padding(.vertical)
            .padding()
            .navigationTitle("Create Bottle")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AddBottleView()
}

