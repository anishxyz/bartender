//
//  RecipeView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/29/23.
//

import SwiftUI


struct RecipeSectionView: View {
    var section: RecipeSection

    var body: some View {
        VStack(alignment: .leading) {
            Text(section.name ?? "Recipe Section \(section.index)")
                .font(.subheadline)
                .bold()
                .padding(.bottom, 5)
            
            VStack(alignment: .leading) {
                ForEach(section.steps ?? [], id: \.self) { step in
                    HStack(alignment: .top) {
                        Text("\(step.index)")
                            .bold()
                            .foregroundColor(Color(UIColor.systemBackground))
                            .frame(width: 28, height: 28)
                            .background(Circle().fill(.orange).colorMultiply(.orange))
                            .padding(.trailing, 8)
                        Text(step.instruction)
                    }
                    .padding(.vertical, 2)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemGray6))
            )
        }
        .padding()
    }
}

