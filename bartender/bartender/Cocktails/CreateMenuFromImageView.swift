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
    
    var onMenuFound: ([TempMenuDetail]) -> Void
    
    public init(onMenuFound: @escaping ([TempMenuDetail]) -> Void) {
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
                
                
                Button(action: {
                    isAnalyzing = true
                    imageToMenu.analyzeImageForCocktailDescriptions(img: selectedImage) { bottles in
                        isAnalyzing = false
                        
                        if bottles.isEmpty {
                            showError = true
                        } else {
                            onMenuFound(bottles)
                        }
                    }
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
