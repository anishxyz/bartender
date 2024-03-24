//
//  BottleEditor.swift
//  bartender
//
//  Created by Anish Agrawal on 3/24/24.
//

import SwiftUI
import SwiftData

struct BottleEditor: View {

    let bottle: Bottle?
    
    private var editorTitle: String {
        bottle == nil ? "Create Bottle" : "Update Bottle"
    }
    
    var body: some View {
        Text("bottle_editor")
    }
}

