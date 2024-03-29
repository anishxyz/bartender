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
    @State var sheetStep: SheetStep? = .upload
    
    var body: some View {
        
        switch sheetStep {
            case .upload:
                GetBottlesFromImageView { bottles in
                    self.sheetStep = .review(bottles)
                }
            case .review(let bottles):
                AddBottlesView(bottles: bottles)
                    .interactiveDismissDisabled(true)
            case .none:
                EmptyView()
        }
    }
}

#Preview {
    BottleUploadViewHandler()
}
