//
//  AddBottleView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/17/23.
//

import SwiftUI

struct AddBottleView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var viewModel: CellarViewModel
    @EnvironmentObject var currUser: CurrUser


    @State private var name: String = ""
    @State private var selectedType: BottleType = .wine
    @State private var quantity: Int = 1
    @State private var price: String = ""
    @State private var description: String = ""
    @State private var selectedBarIndex: Int = 0

    var body: some View {
        NavigationView {
            Form {
                Section() {
                    TextField("Name", text: $name)

                    Picker("Type", selection: $selectedType) {
                        ForEach(BottleType.allCases) { type in
                            HStack {
                                type.symbolFilled
                                    .padding(.trailing, 8) 
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }

                    Stepper(value: $quantity, in: 1...100) {
                        Text("Quantity: \(quantity)")
                    }
                }
                .listRowBackground(Color(UIColor.systemGray6))

                Section() {
                    TextField("Price (optional)", text: $price)
                        .keyboardType(.decimalPad)

                    TextField("Description (optional)", text: $description)
                }
                .listRowBackground(Color(UIColor.systemGray6))
                
                Section(header: Text("Select Bar")) {
                    Picker("Bar", selection: $selectedBarIndex) {
                        Text("None").tag(0)
                        ForEach(viewModel.bars.indices, id: \.self) { index in
                            Text(viewModel.bars[index].name).tag(index + 1)
                        }
                    }
                }
                .listRowBackground(Color(UIColor.systemGray6))

            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Add Bottle")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }, trailing: Button("Add") {
                addBottle()
            })
        }
    }
    
    private func addBottle() {
        let selectedBarId = selectedBarIndex > 0 ? viewModel.bars[selectedBarIndex - 1].bar_id : -1
        let addBottleData = createAddBottleData(name: name, selectedType: selectedType, quantity: quantity, price: price, description: description, bar_id: selectedBarId)
        
        viewModel.addBottleToCellar(bottleData: addBottleData, forUserID: currUser.uid)
        presentationMode.wrappedValue.dismiss()
    }

}


func createAddBottleData(name: String, selectedType: BottleType, quantity: Int, price: String, description: String, bar_id: Int) -> AddBottleData {

    let priceFloat = Float(price) ?? nil
    
    let barIdOptional = bar_id != -1 ? bar_id : nil

    return AddBottleData(
        name: name,
        type: selectedType.rawValue,
        qty: quantity,
        current: true, // Assuming 'current' is always true as per your model
        price: priceFloat,
        description: description,
        bar_id: barIdOptional
    )
}


//
//struct AddBottleView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            AddBottleView()
//                .preferredColorScheme(.light)
//
//            AddBottleView()
//                .preferredColorScheme(.dark)
//        }
//    }
//}
