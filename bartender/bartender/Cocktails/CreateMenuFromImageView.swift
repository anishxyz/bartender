//
//  CreateMenuFromImageView.swift
//  bartender
//
//  Created by Anish Agrawal on 5/9/24.
//

import Foundation
import SwiftUI

struct CreateMenuFromImageView: View {
    @State private var showImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var showingSheet = false
    @State private var isAnalyzing = false
    @State private var showError = false
//    @State private var bottlesFound: [Bottle] = []
        
    private var imageToMenu = ImageToMenu()
    
    var onMenuFound: (CocktailMenu) -> Void
    
    public init(onMenuFound: @escaping (CocktailMenu) -> Void) {
        self.onMenuFound = onMenuFound
    }

    var body: some View {
        VStack(spacing: 20) {
            // TODO: refactor out image picker buttons
            HStack {
                Button {
                    self.imagePickerSourceType = .photoLibrary
                    self.showingSheet = true
                } label: {
                    Text("Camera Roll")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                }
                .buttonStyle(.bordered)
                .tint(.green)
                .padding(.leading)
                .sheet(isPresented: $showingSheet) {
                    ImagePicker(sourceType: self.imagePickerSourceType, selectedImage: self.$selectedImage)
                }
                
                Button {
                    self.imagePickerSourceType = .camera
                    self.showingSheet = true
                } label: {
                    Text("Take Photo")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                }
                .buttonStyle(.bordered)
                .tint(.green)
                .padding(.trailing)
                .sheet(isPresented: $showingSheet) {
                    ImagePicker(sourceType: self.imagePickerSourceType, selectedImage: self.$selectedImage)
                }
            }
            .padding(.top, 30)
            
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .scaledToFit()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 5))
                    .padding(.horizontal)
                
                
                Button{} label: {
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
                .task {
                    // Start the analyzing task when the button is pressed and not already analyzing
                    guard !isAnalyzing else { return }
                    
                    isAnalyzing = true
                    do {
                        if let tempMenu = await imageToMenu.convertToMenu(img: selectedImage) {
                            onMenuFound(tempMenu)
                        } else {
                            showError = true
                        }
                    }
                    isAnalyzing = false
                }
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
    }
}
