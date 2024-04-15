//
//  RecipeSectionView.swift
//  bartender
//
//  Created by Anish Agrawal on 4/15/24.
//

import Foundation
import SwiftUI


struct RecipeSectionView: View {
    var section: RecipeSection

    var body: some View {
        VStack(alignment: .leading) {
            
            if let title = section.title {
                Text(title)
                    .font(.subheadline)
                    .bold()
                    .padding(.bottom, 5)
            }
            
            VStack(alignment: .leading) {
                ForEach(Array(section.sortedSteps.enumerated()), id: \.element.id) { index, step in
                    HStack(alignment: .top) {
                        Circle()
                            .strokeBorder(Color.orange, lineWidth: 2)
                            .background(Circle().fill(Color.orange.opacity(0.2)))
                            .frame(width: 24, height: 24)
                            .overlay(
                                Text("\(index + 1)")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.orange)
                            )
                        Text(step.instruction)
                            .alignmentGuide(.firstTextBaseline) { d in d[VerticalAlignment.center] }
                        Spacer()
                    }
                    .padding(.vertical, 2)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(UIColor.secondarySystemGroupedBackground))
            )
        }
        .padding()
    }
}
