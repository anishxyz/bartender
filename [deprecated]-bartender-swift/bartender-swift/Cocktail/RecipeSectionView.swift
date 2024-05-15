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
                            .font(.caption)
                            .frame(width: 24, height: 24)
                            .background(Circle().fill(.orange).colorMultiply(.orange))
                            .alignmentGuide(.firstTextBaseline) { _ in 12 } // Half of the frame height to center it
                            .padding(.trailing, 8)
                        Text(step.instruction)
                            .font(.body) // Specify the same font size as the default body text or adjust as needed
                            .alignmentGuide(.firstTextBaseline) { d in d[VerticalAlignment.center] }

                    }
                    .padding(.vertical, 2)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.systemGray6))
            )
        }
        .padding()
    }
}

