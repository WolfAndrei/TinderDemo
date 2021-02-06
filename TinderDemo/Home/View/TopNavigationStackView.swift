//
//  TopNavigationStackView.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 22.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: #imageLiteral(resourceName: "app_icon"))
    
    
    private func setupStackView() {
        fireImageView.contentMode = .scaleAspectFit
        
        settingsButton.setImage(UIImage(named: "top_left_profile")?.withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(UIImage(named: "top_right_messages")?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        [settingsButton, fireImageView, messageButton].forEach {addArrangedSubview($0)}
        
        axis = .horizontal
        distribution = .equalSpacing
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
    }
    
}
