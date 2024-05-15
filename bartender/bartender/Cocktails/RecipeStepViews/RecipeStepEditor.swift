//
//  RecipeStepEditor.swift
//  bartender
//
//  Created by Anish Agrawal on 5/15/24.
//

import Foundation
import SwiftUI

struct RecipeStepEditor: View {
    @Binding var step: RecipeStep
    
    var body: some View {
        VStack(spacing: 8) {
            TextField("Instruction", text: $step.instruction)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
