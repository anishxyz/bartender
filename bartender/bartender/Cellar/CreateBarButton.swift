//
//  CreateBar.swift
//  bartender
//
//  Created by Anish Agrawal on 3/30/24.
//

import Foundation
import SwiftUI

struct CreateBarButton: View {
    
    @State private var showingPopup = false
    @State private var barName = ""
    
    var body: some View {
        Button(action: {
            self.showingPopup = true
        }) {
            HStack {
                Text("Create Bar")
                Image("cellar.three.bottles.fill")
            }
        }
        .alert("Create a new bar", isPresented: $showingPopup) {
            TextField("Enter your name", text: $barName)
            Button("OK", action: submit)
        } message: {
            Text("Xcode will print whatever you type.")
        }
    }
    
    func submit() {
        print("New Bar Created \(barName)")
    }
    
}
