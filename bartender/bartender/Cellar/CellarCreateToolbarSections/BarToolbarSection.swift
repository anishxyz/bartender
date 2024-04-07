//
//  BarToolbarSection.swift
//  bartender
//
//  Created by Anish Agrawal on 4/6/24.
//

import SwiftUI


struct BarToolbarSection: View {
    @Binding var showingAddBarSheet: Bool
    @Binding var showingEditBarSheet: Bool
    
    var body: some View {
        Section(header: Text("Bar").font(.headline)) {
            Button(action: {
                showingAddBarSheet = true
            }) {
                HStack {
                    Text("Create Bar")
                    Image("cellar.three.bottles.fill")
                }
            }
            Button(action: {
                showingEditBarSheet = true
            }) {
                HStack {
                    Text("Edit Bars")
                    Image(systemName: "slider.horizontal.2.square")
                }
            }
        }
    }
}

