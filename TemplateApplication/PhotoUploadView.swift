//
//  PhotoUploadView.swift
//  TemplateApplication
//
//  Created by Vishnu Ravi on 2/1/23.
//

import FirebaseCore
import FirebaseStorage
import PhotosUI
import SwiftUI

struct PhotoUploadView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil

    func upload(_ data: Data) {
        let id = UUID().uuidString
        let storage = Storage.storage()
        let storageRef = storage.reference().child("\(id).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"

        storageRef.putData(data, metadata: metadata) { (metadata, error) in
            if let error = error {
                print("Error while uploading file: ", error)
            }

            if let metadata = metadata {
                print("Metadata: ", metadata)
            }
        }
    }

    var body: some View {
        PhotosPicker(
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()) {
                Button("Select a Photo").buttonStyle(.borderedProminent)
            }
            .onChange(of: selectedItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                    }
                }
            }

        if let selectedImageData,
           let uiImage = UIImage(data: selectedImageData) {
            VStack {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                Spacer()
                Button("Upload") {
                    self.upload(selectedImageData)
                }.buttonStyle(.borderedProminent)
            }.padding()
        }
    }
}

struct PhotoUploadView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoUploadView()
    }
}
