//
//  HomeController.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 22.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD


class HomeControllers: UIViewController, SettingsDelegate, LoginControllerDelegate, CardViewDelegate {
    
    func didFinishLogginIn() {
        fetchCurrentUser()
    }
    
    
    var currentUser: User?
    
    let topStackView = TopNavigationStackView()
    let bottomStackView =  HomeBottomControlsStackView()
    let cardsDeckView =  UIView()
    let progressHUD = JGProgressHUD(style: .dark)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonActions()
        setupLayout()
        fetchCurrentUser()
    }
    
    
    fileprivate func setupButtonActions() {
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomStackView.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        
        
    }
    
    
 
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if Auth.auth().currentUser == nil {
//            let registrationController = RegistrationController()
//            registrationController.delegate = self
//            let navController = UINavigationController(rootViewController: registrationController)
//            navController.modalPresentationStyle = .fullScreen
//            present(navController, animated: true, completion: nil)
//        }
    }
    
    func didSaveSettings() {
        fetchCurrentUser()
    }
    
    fileprivate func fetchCurrentUser() {
        progressHUD.textLabel.text = "Loading"
        progressHUD.show(in: view)
        cardsDeckView.subviews.forEach{$0.removeFromSuperview()}
        Firestore.firestore().fetchCurrentUser { (user,error) in
            if let error = error {
                print("Failed to fetch user:", error)
                self.progressHUD.dismiss()
                return
            }
            self.currentUser = user
            self.fetchUsersFromFirestore()
            
        }
    }
    
    @objc func handleRefresh() {
        setupProgressHUD()
        fetchUsersFromFirestore()
    }
    
    fileprivate func setupProgressHUD() {
        
        progressHUD.textLabel.text = "Refreshing"
        progressHUD.show(in: view)
    }
    
    fileprivate func fetchUsersFromFirestore() {
        setupProgressHUD()
        let minAge = currentUser?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
        let maxAge = currentUser?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
        
        let dbReference = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        
        dbReference.getDocuments { (snapshot, error) in
            self.progressHUD.dismiss()
            if let error = error {
                print("Error fetching users", error)
                return
            }
            
            var previousCardView: CardView?
            
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(userDictionary: userDictionary)
                if user.uid != Auth.auth().currentUser?.uid {
                    let cardView = self.setupCardFromUser(user)
                    
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    
                    print("previousNEXT - \(previousCardView?.nextCardView)")
                    print("cardview - \(previousCardView)")
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
        
    }
    
    var topCardView: CardView?
    
    @objc func handleLike() {
        print("removed")
        topCardView?.removeFromSuperview()
        topCardView = topCardView?.nextCardView
        print("!!!!!", topCardView?.nextCardView)
     }
     
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailsController = UserDetailsController()
        userDetailsController.cardVM = cardViewModel
        userDetailsController.modalPresentationStyle = .fullScreen
        present(userDetailsController, animated: true, completion: nil)
    }
    
    fileprivate func setupCardFromUser(_ user: User) -> CardView {
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardVM = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    @objc func handleSettings() {
        let settingsController = SettingsController(style: .grouped)
        settingsController.delegate = self
        let navigationController = UINavigationController(rootViewController: settingsController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomStackView])
        stackView.distribution = .fill
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        stackView.bringSubviewToFront(cardsDeckView)
    }
}



