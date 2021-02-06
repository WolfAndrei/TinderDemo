//
//  LoginViewModel.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 27.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import Foundation
import Firebase

class LoginViewModel {
    
    var email: String? {didSet{checkFormValidity()}}
    var password: String? {didSet{checkFormValidity()}}
    
    var bindableIsFormValid = Bindable<Bool>()
    var bindableIsSigningIn = Bindable<Bool>()
    
    func checkFormValidity() {
        guard let email = email, let password = password else {return}
        let isFormValid = !email.isEmpty && password.count > 5
        bindableIsFormValid.value = isFormValid
    }
    
    func performLogin(completion: @escaping (Error?) -> ()) {
        guard let email = email, let password = password else {return}
        bindableIsSigningIn.value = true
        Auth.auth().signIn(withEmail: email, password: password) { (dataResult, error) in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
}
