//
//  HomeController.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 22.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    
    let topStackView = TopNavigationStackView()
    let bottomStackView =  HomeBottomControlsStackView()
    let cardsDeckView =  UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupDeckView()
    }
    
    let users = [
        User(name: "Kelly", age: 23, profession: "Music DJ", photoName: "lady5c"),
        User(name: "Jane", age: 18, profession: "Teacher", photoName: "lady4c")
    ]
    
    fileprivate func setupDeckView() {
        
        users.forEach { user in
            let cardView = CardView(frame: .zero)
            cardView.user = user
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
        
        
    }
    
    fileprivate func setupLayout() {
        
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



