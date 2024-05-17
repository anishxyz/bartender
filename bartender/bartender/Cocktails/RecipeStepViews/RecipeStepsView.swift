//
//  RecipeStepsView.swift
//  bartender
//
//  Created by Anish Agrawal on 4/19/24.
//

import Foundation
import SwiftUI

struct RecipeStepsView: View {
    var steps: [RecipeStep]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Recipe Steps")
                .font(.subheadline)
                .bold()
                .padding(.bottom, 5)
            
            VStack(alignment: .leading) {
                ForEach(Array(steps.sorted { $0.index < $1.index }.enumerated()), id: \.element.id) { index, step in
                    HStack(alignment: .top) {
                        RecipeStepIndexCircle(index: index)
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
