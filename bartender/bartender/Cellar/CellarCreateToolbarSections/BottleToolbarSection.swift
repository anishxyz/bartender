//
//  CellarCreateToolbar.swift
//  bartender
//
//  Created by Anish Agrawal on 4/6/24.
//

import SwiftUI


struct BottleToolbarSection: View {
    @Binding var showingAddBottleSheet: Bool
    @Binding var showingAddBottleFromImageSheet: Bool
    
    var body: some View {
        Section(header: Text("Bottle").font(.headline)) {
            Button(action: {
                showingAddBottleSheet = true
            }) {
                HStack {
                    Text("Add Manually")
                    Image(systemName: "square.and.pencil")
                }
            }
            Button(action: {
                showingAddBottleFromImageSheet = true
            }) {
                HStack {
                    Text("From Image")
                    Image(systemName: "photo")
                }
            }
        }
    }
}
