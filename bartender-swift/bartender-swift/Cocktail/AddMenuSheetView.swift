//
//  AddMenuSheetView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/24/23.
//

import SwiftUI

struct AddMenuSheetView: View {
    @EnvironmentObject var viewModel: CocktailViewModel
    @EnvironmentObject var currUser: CurrUser
    @Binding var isPresented: Bool
    @State private var menuName: String = ""

    var body: some View {
        VStack {
            TextField("Enter menu name", text: $menuName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Create Menu") {
                viewModel.createMenu(name: menuName, userID: currUser.uid)
                isPresented = false
            }
            .buttonStyle(.borderedProminent)
            .disabled(menuName.isEmpty)
            Spacer()
        }
        .padding()
    }
}

