//
//  AddBottleImageView.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 1/6/24.
//

import SwiftUI
import PhotosUI

struct AddBottleImageView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: CellarViewModel
    @EnvironmentObject var currUser: CurrUser
    @EnvironmentObject var loadingState: LoadingStateViewModel
    
    @Binding var isPresented: Bool

    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var image: Image?
    @State private var pickerSourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @State private var selectedBarId: Int? = nil
    @State private var selectedBarIndex: Int = 0

    var body: some View {
        VStack {
            HStack {
                Button("Upload from Camera Roll") {
                    self.pickerSourceType = .photoLibrary
                    self.showImagePicker = true
                }
                .buttonStyle(.bordered)
                .tint(.orange)
                .sheet(isPresented: $showImagePicker) {
                    CustomImagePicker(image: self.$inputImage, sourceType: self.pickerSourceType)
                }

                Button("Use Camera") {
                    self.pickerSourceType = .camera
                    self.showImagePicker = true
                }
                .buttonStyle(.bordered)
                .tint(.orange)
                .sheet(isPresented: $showImagePicker) {
                    CustomImagePicker(image: self.$inputImage, sourceType: self.pickerSourceType)
                }
            }
            .padding()
            
            Menu {
                Picker("Select Bar", selection: $selectedBarId) {
                    Text("None").tag(nil as Int?)
                    ForEach(viewModel.bars, id: \.bar_id) { bar in
                        Text(bar.name).tag(bar.bar_id as Int?)
                    }
                }
            } label: {
                Label("Select a Bar", systemImage: "cellar.three.bottles")
            }
            .padding(.bottom)
            .buttonStyle(.bordered)
            .tint(.orange)

//            // Display the selected bar
//            if let barId = selectedBarId {
//                Text("Selected Bar ID: \(barId)")
//                    .padding()
//            } else {
//                Text("No Bar Selected")
//                    .padding()
//            }


            if let image = image {
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: 250, height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 10)) // Rounded corners
                    .overlay(
                        RoundedRectangle(cornerRadius: 10) // Tinted border
                            .stroke(Color.blue, lineWidth: 2) // Replace `Color.blue` with your preferred tint color
                    )
                Button("Submit") {
                    loadingState.startLoading()
                    submitBottleImage()
                }
                .padding()
                .buttonStyle(.bordered)
                .tint(.green)
            }
            Spacer()
        }
        .onChange(of: inputImage) { _ in
            if let inputImage = inputImage {
                self.image = Image(uiImage: inputImage)
            }
        }
    }
    
    private func submitBottleImage() {
        guard let inputImage = inputImage,
            let imageData = inputImage.jpegData(compressionQuality: 1.0) else {
            print("No image to submit")
            return
        }

        let base64Image = imageData.base64EncodedString(options: .lineLength64Characters)
        let userId = currUser.uid

        viewModel.addBottlesToCellarImage(fromImage: imageData, base64Image: base64Image, userID: userId, barID: selectedBarId) {
            loadingState.stopLoading()
        }
        isPresented = false
    }
}

struct CustomImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    var sourceType: UIImagePickerController.SourceType

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CustomImagePicker

        init(_ parent: CustomImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }

            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

//struct AddBottleImageView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            AddBottleImageView()
//                .preferredColorScheme(.light)
//
//            AddBottleImageView()
//                .preferredColorScheme(.dark)
//        }
//    }
//}
