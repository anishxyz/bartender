//
//  EditBarsView.swift
//  bartender
//
//  Created by Anish Agrawal on 4/6/24.
//

import SwiftUI

struct EditBarsView: View {
    @Environment(\.modelContext) private var modelContext
    var bars: [Bar]
    
    
    var body: some View {
        List(bars) { bar in
            HStack {
                Text(bar.name)
                Spacer()
                Button {
                    modelContext.delete(bar)
                } label: {
                    Image(systemName: "trash.fill")
                        .foregroundStyle(.red)
                }
            }
            .swipeActions {
                Button("Delete", systemImage: "trash", role: .destructive) {
                    modelContext.delete(bar)
                }
            }
        }
    }
}

