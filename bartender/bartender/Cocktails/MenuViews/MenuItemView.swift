//
//  MenuItemView.swift
//  bartender
//
//  Created by Anish Agrawal on 4/12/24.
//

import Foundation
import SwiftUI

struct MenuItemView: View {
    var menu: CocktailMenu
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Rectangle()
                .frame(height: 100)
                .foregroundColor(.clear)
            
            Text(menu.name)
                .bold()
                .padding()
                .frame(alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
}
