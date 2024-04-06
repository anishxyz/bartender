//
//  BarPicker.swift
//  bartender
//
//  Created by Anish Agrawal on 4/5/24.
//

import SwiftUI
import SwiftData

struct BarPicker: View {
    @Binding var selectedBar: Bar?
    
    @Query(sort:
            [SortDescriptor(\Bar.created_at, order: .reverse),
             SortDescriptor(\Bar.name)]
    ) var bars: [Bar]

    var body: some View {
        Menu {
            // Button for selecting "None"
            Button(action: {
                self.selectedBar = nil
            }) {
                HStack {
                    Text("None")
                    if selectedBar == nil {
                        Spacer()
                        Image(systemName: "checkmark")
                            .foregroundColor(.blue)
                    }
                }
            }

            // Existing code for selecting a bar
            ForEach(bars, id: \.self) { bar in
                Button(action: {
                    self.selectedBar = bar
                }) {
                    HStack {
                        Text(bar.name)
                        if selectedBar?.id == bar.id { // Assuming Bar has an 'id' field for uniqueness
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
                    Text(selectedBar?.name ?? "Select a Bar") // Display "Select a Bar" when no bar is selected
                    Image(systemName: "chevron.up.chevron.down")
                }
            }
            .buttonStyle(.bordered)
            .tint(.orange)
        }
    }
}
