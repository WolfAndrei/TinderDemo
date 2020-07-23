//
//  HomeControlsStackView.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 22.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func createButtons() -> [UIButton] {
        let bottomToolbar = [#imageLiteral(resourceName: "refresh_circle"), #imageLiteral(resourceName: "dismiss_circle"), #imageLiteral(resourceName: "super_like_circle"), #imageLiteral(resourceName: "like_circle"), #imageLiteral(resourceName: "boost_circle")].map { (image) -> UIButton in
            let button = UIButton()
            button.setImage(image, for: .normal)
            return button
        }
        return bottomToolbar
    }
    
    private func setupStackView() {
        let bottomSubviews = createButtons()
        bottomSubviews.forEach {addArrangedSubview($0)}
        axis = .horizontal
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
}
