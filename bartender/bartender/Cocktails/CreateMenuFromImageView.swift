//
//  CreateMenuFromImageView.swift
//  bartender
//
//  Created by Anish Agrawal on 5/9/24.
//

import Foundation
import SwiftUI
import SwiftData

struct CreateMenuFromImageView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var selectedImage: UIImage?
    @State private var isAnalyzing = false
    @State private var showError = false
    @State private var isSheetDismissable = true
//    @State private var bottlesFound: [Bottle] = []
        
    private var imageToMenu = ImageToMenu()
    
    var onMenuFound: (CocktailMenu) -> Void
    
    public init(onMenuFound: @escaping (CocktailMenu) -> Void) {
        self.onMenuFound = onMenuFound
    }

    var body: some View {
        VStack(spacing: 20) {
            // TODO: refactor out image picker buttons
            ImagePickerButtons(selectedImage: $selectedImage)
                .padding(.top, 30)
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .scaledToFit()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 5))
                    .padding(.horizontal)
                
                
                Button {
                    Task {
                        guard !isAnalyzing else { return }

                        isAnalyzing = true
                        isSheetDismissable = false
                        do {
                            if let tempMenu = await imageToMenu.convertToMenu(img: selectedImage, context: modelContext) {
                                onMenuFound(tempMenu)
                            } else {
                                showError = true
                            }
                        }
                        isAnalyzing = false
                        isSheetDismissable = true
                    }
                } label: {
                    if isAnalyzing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                    } else {
                        Text("Generate Menu")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                    }
                }
                .buttonStyle(.bordered)
                .tint(.orange)
                .disabled(isAnalyzing)
                .padding(.horizontal)
            }
            
            if showError {
                Text("Cocktail menu not detected. Please try another image.")
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(Color.red)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            Spacer()
        }
        .interactiveDismissDisabled(!isSheetDismissable)
    }
}
