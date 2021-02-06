//
//  FirebaseExtensions.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 27.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import Foundation
import Firebase

extension Firestore {
    
    
    func fetchCurrentUser(completion: @escaping(User?, Error?)->()) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let dbRef = Firestore.firestore().collection("users").document(uid)
        dbRef.getDocument { (docSnapshot, error) in
            if let error = error {
                print("Failed fetch info about current user", error)
                return
            }
            print("SuccessfullyFetched")
            guard let userDictionary = docSnapshot?.data() else {
                let error = NSError(domain: "com.wolfAndrei.TinderDemo", code: 500, userInfo: [NSLocalizedDescriptionKey: "No user found in Firestore"])
                completion(nil, error)
                return
            }
            let user  = User(userDictionary: userDictionary)
            completion(user, nil)
        }
        
    }
}
