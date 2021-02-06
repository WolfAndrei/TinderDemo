//
//  RegistrationViewModel.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 24.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    var bindableIsRegistering = Bindable<Bool>()
    
    var fullName: String? {didSet{checkFormValidity()}}
    var email: String? {didSet{checkFormValidity()}}
    var password: String? {didSet{checkFormValidity()}}
    
    func checkFormValidity() {
        if let fullName = self.fullName, let email = self.email, let password = self.password {
            let isFormValid = !fullName.isEmpty && !email.isEmpty && password.count > 5 && bindableImage.value != nil
            bindableIsFormValid.value = isFormValid
        }
    }
    
    private func storeImage(completion: @escaping (Error?) -> ()) {
        guard let uploadData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) else {return}
        let filename = UUID().uuidString
        
        let storageReference = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        storageReference.putData(uploadData, metadata: nil) { (storageMetadata, error) in
            if let error = error {
                completion(error)
                return
            }
            print("Successfully uploaded image to storage")
            storageReference.downloadURL { (url, error) in
                if let error = error {
                    completion(error)
                    return
                }
                self.bindableIsRegistering.value = false
                print("Successfully fetch download url")
                
                let urlString = url?.absoluteString ?? ""
                self.saveInfoToFireStore(imageURL: urlString, completion: completion)
            }
        }
    }
    
    fileprivate func saveInfoToFireStore(imageURL: String, completion: @escaping (Error?)->()) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let documentData: [String: Any] = ["fullName": fullName ?? "",
                            "uid": uid,
                            "image1Url": imageURL,
                            "age" : 18,
                            "minSeekingAge" : SettingsController.defaultMinSeekingAge,
                            "maxSeekingAge" : SettingsController.defaultMaxSeekingAge
                            ]
        let dbReference = Firestore.firestore()
        dbReference.document("users/\(uid)").setData(documentData) { (error) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
        
        
    }
    
    func performRegistration(completion: @escaping (Error?) -> ()) {
        bindableIsRegistering.value = true
        guard let email = email, let password = password else {return}
        Auth.auth().createUser(withEmail: email, password: password) { (dataResult, error) in
            if let error = error {
                completion(error)
                return
            }
            print("Successfully created")
            self.storeImage(completion: completion)
        }
    }
    
}
