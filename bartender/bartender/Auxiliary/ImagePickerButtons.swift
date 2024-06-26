//
//  ImagePickerButtons.swift
//  bartender
//
//  Created by Anish Agrawal on 5/14/24.
//

import SwiftUI

struct ImagePickerButtons: View {
    @State private var imagePickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showingSheet = false
    
    @Binding var selectedImage: UIImage?

    var body: some View {
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
    }
}
