//
//  BottleUploadViewHandler.swift
//  bartender
//
//  Created by Anish Agrawal on 3/26/24.
//

import SwiftUI

enum SheetStep {
    case upload
    case review([Bottle])
}

struct BottleUploadViewHandler: View {
    @Binding var sheetStep: SheetStep?
    
    var body: some View {
        switch sheetStep {
        case .upload:
            UploadImageView { bottles in
                self.sheetStep = .review(bottles)
            }
        case .review(let bottles):
            ReviewBottlesView(bottles: bottles)
        case .none:
            EmptyView()
        }
    }
}

