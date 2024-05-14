//
//  AddBottleFromImageView.swift
//  bartender
//
//  Created by Anish Agrawal on 3/26/24.
//

// TODO: Add icons for upload, capture, and error

import SwiftUI

struct GetBottlesFromImageView: View {
    @State private var showImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var showingSheet = false
    @State private var isAnalyzing = false
    @State private var showError = false
    @State private var isSheetDismissable = true
//    @State private var bottlesFound: [Bottle] = []
        
    private var imageToCellar = ImageToCellar()
    
    var onBottlesFound: ([Bottle]) -> Void
    
    public init(onBottlesFound: @escaping ([Bottle]) -> Void) {
        self.onBottlesFound = onBottlesFound
    }

    var body: some View {
        VStack(spacing: 20) {
            
            ImagePickerButtons(imagePickerSourceType: $imagePickerSourceType, selectedImage: $selectedImage, showingSheet: $showingSheet)
                .padding(.top, 30)
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .scaledToFit()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 5))
                    .padding(.horizontal)
                
                
                Button(action: {
                    isAnalyzing = true
                    isSheetDismissable = false
                    imageToCellar.analyzeImage(img: selectedImage) { bottles in
                        isAnalyzing = false
                        
                        if bottles.isEmpty {
                            showError = true
                        } else {
//                            bottlesFound = bottles
                            onBottlesFound(bottles)
                        }
                    }
                    isSheetDismissable = true
//                    onBottlesFound(sampleBottles.contents)
                }) {
                    if isAnalyzing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                    } else {
                        Text("Get Bottles")
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
                Text("No bottles detected. Please try another image.")
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
