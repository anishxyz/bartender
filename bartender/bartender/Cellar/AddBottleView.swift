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

    @State private var name: String = ""
    @State private var type: BottleType = .wine // Assuming BottleType is an enum and .red is a placeholder value
    @State private var qty: Int = 1
    @State private var price: String = ""
    @State private var info: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    LabeledContent {
                        TextField("Required", text: $name)
                            .multilineTextAlignment(.trailing)
                    } label: {
                        Text("Name")
                            .bold()
                    }
                    Picker("Type", selection: $type) {
                        ForEach(BottleType.allCases, id: \.self) { type in
                            Text(type.rawValue)
                                .tag(type)
                        }
                    }
                    .bold()
                }
                
                Section {
                    Stepper("Quantity: \(qty)", value: $qty, in: 1...100)
                        .bold()
                    
                    LabeledContent {
                        TextField("Optional", text: $price)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    } label: {
                        Text("Price")
                            .bold()
                    }
                    
                    LabeledContent {
                        TextField("Optional", text: $info)
                            .multilineTextAlignment(.trailing)
                    } label: {
                        Text("Description")
                            .bold()
                    }

                }

                Section {
                    Button("Save") {
                        let finalPrice = Float(price) ?? nil
                        let newBottle = Bottle(name: name, type: type, qty: qty, price: finalPrice, info: info)
                        // TODO: Add to persistent data storage
                        modelContext.insert(newBottle)
                        dismiss()
                    }
                    .bold()
                }
            }
            .navigationTitle("Create Bottle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddBottleView()
}
