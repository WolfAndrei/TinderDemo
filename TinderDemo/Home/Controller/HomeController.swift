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

class HomeController: UIViewController {
    
    //MARK: - CONSTANTS && VARIABLES
    
    var currentUser: User?
    var swipes = [String: Int]()
    var users = [String: User]()
    var topCardView: CardView?
    
    //MARK: - INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonActions()
        setupLayout()
        fetchCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil {
            let registrationController = RegistrationController()
            registrationController.delegate = self
            let navController = UINavigationController(rootViewController: registrationController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
        }
    }
    
    //MARK: - UI ELEMENTS
    
    let topStackView = TopNavigationStackView()
    let bottomStackView =  HomeBottomControlsStackView()
    let cardsDeckView =  UIView()
    let progressHUD = JGProgressHUD(style: .dark)
    
    //MARK: - USER INTERACTIONS
    
    fileprivate func setupButtonActions() {
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomStackView.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        bottomStackView.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        bottomStackView.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        topStackView.messageButton.addTarget(self, action: #selector(handleMessaging), for: .touchUpInside)
    }
    
    @objc func handleSettings() {
        let settingsController = SettingsController(style: .grouped)
        settingsController.delegate = self
        let navigationController = UINavigationController(rootViewController: settingsController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func handleRefresh() {
        setupProgressHUD()
        cardsDeckView.subviews.forEach{$0.removeFromSuperview()}
        fetchUsersFromFirestore()
    }
    
    @objc func handleLike() {
        saveSwipeInfo(didLike: 1)
        preformSwipeAnimation(translation: 600, angle: 20)
    }
    
    @objc func handleDislike() {
        saveSwipeInfo(didLike: 0)
        preformSwipeAnimation(translation: -600, angle: -20)
    }
    
    @objc func handleMessaging() {
        let vc = MatchesMessagesController()
        vc.view.backgroundColor = .red
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - DEFAULT METHODS
    //MARK: - CUSTOM METHODS
    
    fileprivate func setupProgressHUD() {
        progressHUD.textLabel.text = "Refreshing"
        progressHUD.show(in: view)
    }
    
    fileprivate func presentMatchView(cardUID: String) {
        let matchView = MatchView()
        matchView.cardUID = cardUID
        matchView.currentUser = currentUser
        view.addSubview(matchView)
        matchView.fillSuperview()
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
    
    //MARK: - FIREBASE METHODS
    
    fileprivate func fetchCurrentUser() {
        progressHUD.textLabel.text = "Loading"
        progressHUD.show(in: view)
        cardsDeckView.subviews.forEach{$0.removeFromSuperview()}
        Firestore.firestore().fetchCurrentUser { (user,error) in
            if let error = error {
                print("Failed to fetch user:", error)
                return
            }
            self.progressHUD.dismiss()
            self.currentUser = user
            self.fetchSwipes()
        }
    }
    
    fileprivate func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("swipes").document(uid).getDocument { (docSnapshot, error) in
            if let error = error {
                print("Failed to fetch swipes", error)
                return
            }
            if let data = docSnapshot?.data() as? [String: Int] {
                self.swipes = data
            }
            self.fetchUsersFromFirestore()
        }
    }
    
    fileprivate func fetchUsersFromFirestore() {
        setupProgressHUD()
        let minAge = currentUser?.minSeekingAge ?? SettingsController.defaultMinSeekingAge
        let maxAge = currentUser?.maxSeekingAge ?? SettingsController.defaultMaxSeekingAge
        
        let dbReference = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge).limit(to: 10)
        topCardView = nil
        dbReference.getDocuments { (snapshot, error) in
            self.progressHUD.dismiss()
            if let error = error {
                print("Error fetching users", error)
                return
            }
            //LINKED LIST
            var previousCardView: CardView?
            
            snapshot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(userDictionary: userDictionary)
                
                self.users[user.uid ?? ""] = user
                
                let isNotCurrentUser = user.uid != Auth.auth().currentUser?.uid
                //                let hasNotSwipedBefore = self.swipes[user.uid!] == nil
                let hasNotSwipedBefore = true
                if isNotCurrentUser && hasNotSwipedBefore {
                    
                    let cardView = self.setupCardFromUser(user)
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    
                    if self.topCardView == nil {
                        self.topCardView = cardView
                    }
                }
            })
        }
    }

    fileprivate func saveSwipeInfo(didLike: Int) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let dbRef = Firestore.firestore().collection("swipes").document(uid)
        guard let cardUID = topCardView?.cardVM?.uid else {return}
        let docData = [cardUID : didLike]
        
        if didLike == 1 {
            self.checkIfMatchExists(cardUID: cardUID)
        }
        dbRef.getDocument { (docSnapshot, error) in
            if let error = error {
                print("Failed to fetch swipe data", error)
                return
            }
            if docSnapshot!.exists {
                dbRef.updateData(docData) { (error) in
                    if let error = error {
                        print("Failed to update swipe data", error)
                        return
                    }
                    print("Successfully updated swipe")
                }
            } else {
                dbRef.setData(docData) { (error) in
                    if let error = error {
                        print("Failed to save swipe data", error)
                        return
                    }
                    print("Successfully saved swipe")
                }
            }
        }
    }
    
    fileprivate func fetchMatches(fromUser: User, toUser: User) {
        let docData = ["name" : toUser.name ?? "",
                       "profileImageURL" : toUser.image1Url as Any,
                       "uid" : toUser.uid ?? "",
                       "date" : Timestamp(date: Date())
        ]
        
        Firestore.firestore().collection("matches_messages").document(fromUser.uid ?? "").collection("matches").document(toUser.uid ?? "").setData(docData) { (error) in
             if let error = error {
                 print("failed to save matches data", error)
                 return
             }
             print("Successfully saved data to db")
         }
    }
    
    fileprivate func checkIfMatchExists(cardUID: String) {
        
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (docSnapshot, error) in
            if let error = error {
                print("Failed to fetch document for card user:", error)
                return
            }
            guard let data = docSnapshot?.data() else {return}
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let hasMatched = data[uid] as? Int == 1
            if hasMatched {
                
                self.presentMatchView(cardUID: cardUID)
                
                guard let cardUser = self.users[cardUID] else {return}
                guard let currentUser = self.currentUser else {return}
                
                self.fetchMatches(fromUser: currentUser, toUser: cardUser)
                self.fetchMatches(fromUser: cardUser, toUser: currentUser)
            }
        }
    }
    
    //MARK: - ANIMATION
    
    fileprivate func preformSwipeAnimation(translation: CGFloat, angle: CGFloat) {
        CATransaction.begin()
        let anim = CABasicAnimation(keyPath: "transform")
        topCardView?.layer.shouldRasterize = true
        topCardView?.layer.rasterizationScale = UIScreen.main.scale
        
        anim.toValue = NSValue(caTransform3D: CATransform3DConcat(CATransform3DMakeRotation(angle.convertPIinDegree(), 0, 0, 1), CATransform3DMakeTranslation(translation, 0, 0)))
        
        anim.duration = 0.65
        anim.timingFunction = CAMediaTimingFunction(name: .easeOut)

        let cardView = topCardView
        topCardView = cardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.layer.shouldRasterize = false
            cardView?.removeFromSuperview()
            self.cardsDeckView.isUserInteractionEnabled = true
        }
        cardView?.layer.add(anim, forKey: "translation")
        CATransaction.commit()
    }
}

//MARK: - EXTENSIONS

extension HomeController: CardViewDelegate {
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailsController = UserDetailsController()
        userDetailsController.cardVM = cardViewModel
        userDetailsController.modalPresentationStyle = .fullScreen
        present(userDetailsController, animated: true, completion: nil)
    }
    
}

extension HomeController: LoginControllerDelegate {
    func didFinishLogginIn() {
        fetchCurrentUser()
    }
}

extension HomeController: SettingsDelegate {
    func didSaveSettings() {
        fetchCurrentUser()
    }
}
