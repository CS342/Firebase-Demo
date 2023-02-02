//
//  StorageManager.swift
//  TemplateApplication
//
//  Created by Vishnu Ravi on 2/2/23.
//

import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class StorageManager {
    static let shared = StorageManager()
    
    func uploadImage(_ data: Data) {
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

    func fetchAllResults() {
        let db = Firestore.firestore()
        db.collection("image-result").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                guard let querySnapshot else { return }
                for document in querySnapshot.documents {
                    print("\(document.documentID): \(document.data())")
                }
            }
        }
    }
}
