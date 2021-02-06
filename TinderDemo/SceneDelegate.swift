//
//  SceneDelegate.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 22.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let win = UIWindow(windowScene: windowScene)
        
        print(Auth.auth().currentUser?.uid)
        
        if Auth.auth().currentUser?.uid != nil {
            win.rootViewController = UINavigationController(rootViewController: HomeController())
        } else {
            win.rootViewController = UINavigationController(rootViewController: RegistrationController())
        }
        win.makeKeyAndVisible()
        window = win
        
    }
    
}

