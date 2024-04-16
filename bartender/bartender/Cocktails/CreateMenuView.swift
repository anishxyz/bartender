//
//  CreateMenu.swift
//  bartender
//
//  Created by Anish Agrawal on 4/15/24.
//

import Foundation
import SwiftUI


struct CreateMenuView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var menu: CocktailMenu = CocktailMenu(name: "", info: nil)
    @State private var tempInfo: String = ""

    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    LabeledContent {
                        TextField("Required", text: $menu.name)
                            .multilineTextAlignment(.trailing)
                    } label: {
                        Text("Name")
                            .bold()
                    }
                    Divider()
                    VStack(alignment: .leading) {
                        Text("Description")
                            .bold()
                        TextField("Optional", text: $tempInfo, axis: .vertical)
                            .lineLimit(6)
                            .onChange(of: tempInfo) {
                                menu.info = tempInfo.isEmpty ? nil : tempInfo
                            }
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(.gray).opacity(0.1))
            }
            .padding(12)
            .background(RoundedRectangle(cornerRadius: 22).fill(.gray).opacity(0.15))
            .padding()
            Spacer()
            HStack {
                Button(action: {
                    if !menu.name.isEmpty {
                        modelContext.insert(menu)
                        dismiss()
                    }
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .imageScale(.large)
                        Text("Create Menu")
                    }
                }
                .buttonStyle(.bordered)
                .frame(maxWidth: .infinity)
                .tint(.orange)
            }
        }
    }
}
