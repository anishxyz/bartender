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
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Toolbar")
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                            Text("Cancel")
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.red)
                    
                    Button(action: {
                        // TODO: Fix error handling
                        do {
                            try modelContext.transaction {
                                for bott in bottles {
                                    modelContext.insert(bott)
                                }
                                do {
                                    try modelContext.save()
                                } catch {
                                    print("An error saving: \(error)")
                                }
                            }
                        } catch {
                            print("An error occurred: \(error)")
                        }
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .imageScale(.large)
                            Text("Save")
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)
                }
                .padding(.top, 30)
                
                ForEach($bottles.indices, id: \.self) { index in
                    EditBottleView(bottle: $bottles[index])
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 22).fill(.gray).opacity(0.15))
                        .padding(.vertical)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    AddBottlesView(bottles: sampleBottles.contents)
}
