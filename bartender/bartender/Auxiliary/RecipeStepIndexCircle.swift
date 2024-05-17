//
//  RecipeStepIndexCircle.swift
//  bartender
//
//  Created by Anish Agrawal on 5/17/24.
//

import SwiftUI

struct RecipeStepIndexCircle: View {
    let index: Int
    
    var body: some View {
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
    }
}
