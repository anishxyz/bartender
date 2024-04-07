//
//  CellarEditToolbarButton.swift
//  bartender
//
//  Created by Anish Agrawal on 4/7/24.
//

import SwiftUI

struct CellarEditToolbarButton: View {
    
    @Binding private var editMode: EditMode
    @Binding private var showingEditBarSheet: Bool
    let toggleEditMode: () -> Void
    
    init(editMode: Binding<EditMode>, showingEditBarSheet: Binding<Bool>, toggleEditMode: @escaping () -> Void) {
        self._editMode = editMode
        self._showingEditBarSheet = showingEditBarSheet
        self.toggleEditMode = toggleEditMode
    }
    
    var body: some View {
        if editMode == .inactive {
            Menu {
                Button(action: toggleEditMode) {
                    HStack {
                        Text("Add Bottles to Bar")
                        Image(systemName: "plus.square")
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
            } label: {
                Text(editMode.isEditing ? "Done" : "Edit")
                    .bold()
                    .font(.system(size: 14))
            }
            .menuStyle(ButtonMenuStyle())
            .clipShape(.capsule)
            .buttonStyle(.bordered)
            .tint(.orange)
        } else {
            Button(action: toggleEditMode) {
                Text(editMode.isEditing ? "Done" : "Edit")
                    .bold()
                    .font(.system(size: 14))
            }
            .clipShape(.capsule)
            .buttonStyle(.bordered)
            .tint(.orange)
        }
    }
}
