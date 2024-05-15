//
//  MenuCardView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/24/23.
//

import SwiftUI

struct MenuCardView: View {
    let menu: CocktailMenu // Assume Menu is your data model type

    var body: some View {
        VStack(alignment: .leading) {
            Text(menu.name ?? "Unknown Menu")
                .font(.headline)
                .padding([.top, .leading, .trailing])
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 100)
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .foregroundColor(Color.primary)
    }
}


struct MenuCardView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a mock CocktailMenu with all required properties
        let mockMenu = CocktailMenu(
            menu_id: 1,
            created_at: Date(),
            updated_at: Date(),
            uid: UUID(),
            name: "Mocktail Menu",
            cocktails: []
        )

        return Group {
            MenuCardView(menu: mockMenu)
                .padding()
                .environment(\.colorScheme, .light)

            MenuCardView(menu: mockMenu)
                .padding()
                .environment(\.colorScheme, .dark)
        }
    }
}
