//
//  EditBottleView.swift
//  bartender
//
//  Created by Anish Agrawal on 3/26/24.
//

import SwiftUI
import UIKit

struct EditBottleView: View {
    @Binding var bottle: Bottle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Group {
                VStack {
                    LabeledContent {
                        TextField("Required", text: $bottle.name)
                            .multilineTextAlignment(.trailing)
                    } label: {
                        Text("Name")
                            .bold()
                    }
                    Divider()
                    HStack {
                        Text("Type").bold()
                        Spacer()
                        BottleTypePicker(selectedType: $bottle.type)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.1))
                          
            }
            
            Group {
                VStack {
                    // BarPicker(selectedBar: $bottle.bar) buggy
                    
                    Stepper("Quantity: \(bottle.qty)", value: $bottle.qty, in: 1...100)
                        .bold()
                    
                    Divider()
                    
                    LabeledContent {
                        TextField("Optional", text: Binding<String>(
                            get: {
                                if let price = self.bottle.price {
                                    return String(format: "%.2f", price)
                                } else {
                                    return ""
                                }
                            },
                            set: {
                                if let value = Float($0) {
                                    self.bottle.price = value
                                } else {
                                    self.bottle.price = nil
                                }
                            }
                        ))
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.decimalPad)
                    } label: {
                        Text("Price")
                            .bold()
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Description")
                            .bold()
                        TextField("Optional", text: Binding<String>(
                            get: { self.bottle.info ?? "" },
                            set: { self.bottle.info = $0.isEmpty ? nil : $0 }
                        ), axis: .vertical)
                        .lineLimit(6)
                    }
                
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.1))
            }
        }
    }
}


#Preview {
    EditBottleView(bottle: .constant(Bottle(name: "Don Julio 1942", type: .tequila, qty: 1, price: 750.00, info: "Tequila Don Julio was established in 1942 when Don Julio Gonzalez was only 17 years old. He produced tequila for the locals, family, and special occasions. In the early 1980’s Don Julio suffered a very bad stroke and in 1985 they threw him an enormous party to celebrate his recovery as well as his 60th birthday. The original bottles were tall like many other brands but Don Julio wanted his guests to be able to see each other while seated at tables for the party. The brand officially launched in 1987 and is now a staple in the premium Tequila category.")))
}


