//
//  AddBarSheetView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/31/23.
//

import SwiftUI

struct AddBarSheetView: View {
    @EnvironmentObject var viewModel: CellarViewModel
    @EnvironmentObject var currUser: CurrUser
    @EnvironmentObject var loadingState: LoadingStateViewModel
    
    @Binding var isPresented: Bool
    @State private var barName: String = ""
    @State private var barDescription: String = ""


    var body: some View {
        VStack {
            TextField("Enter Bar Name", text: $barName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Enter Bar Description", text: $barDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Create Bar") {
                loadingState.startLoading()
                viewModel.createBar(name: barName, description: barDescription, userID: currUser.uid) {
                    loadingState.stopLoading()
                }
                isPresented = false
            }
            .buttonStyle(.borderedProminent)
            .disabled(barName.isEmpty)
            Spacer()
        }
        .padding()
    }
}


