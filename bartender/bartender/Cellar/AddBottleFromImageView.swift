//
//  AddBottleFromImageView.swift
//  bartender
//
//  Created by Anish Agrawal on 3/26/24.
//

import SwiftUI

struct AddBottleFromImageView: View {
    @State private var showImagePicker = false
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var showingSheet = false
    @State private var isAnalyzing = false
    
    private var imageToCellar = ImageToCellar()

    var body: some View {
        VStack {
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
                .padding([.leading, .bottom])
                .padding(.top, 40)
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
                .padding([.trailing, .bottom])
                .padding(.top, 40)
                .sheet(isPresented: $showingSheet) {
                    ImagePicker(sourceType: self.imagePickerSourceType, selectedImage: self.$selectedImage)
                }
            }
            if let selectedImage = selectedImage {
                Image(uiImage: selectedImage)
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .scaledToFit()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.orange, lineWidth: 5))
                    .padding()
                    
                
                Button(action: {
                    isAnalyzing = true
                    imageToCellar.analyzeImage(img: selectedImage) {
                        isAnalyzing = false
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
                .padding()
            }
            Spacer()
        }
    }
}

#Preview {
    AddBottleFromImageView()
}
