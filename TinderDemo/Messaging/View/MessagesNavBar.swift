//
//  MessagesNavBar.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 30.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class MessagesNavBar: UIView {
    
    //MARK: - CONSTANTS && VARIABLES
    
    fileprivate var match : Match
    fileprivate var imageHeight: CGFloat = 84.0
    
    //MARK: - INITIALIZATION
    
    init(match: Match) {
        self.match = match
        super.init(frame: .zero)
        setupLayout()
        setupViewWithData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI ELEMENTS
    
    fileprivate let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    fileprivate let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor =  #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        return button
    }()
    
    let flagButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "flag").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor =  #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        return button
    }()
    
    //MARK: - DEFAULT METHODS

    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView.layer.cornerRadius = imageHeight / 2
    }
    
    //MARK: - CUSTOM METHODS
    
    fileprivate func setupLayout() {        
        backgroundColor = .white

        //setup shadow tint
        setupShadow(opacity: 0.7, radius: 8, offset: .init(width: 0, height: 10), color: UIColor(white: 0, alpha: 0.3))
        
        //setup stack views
        let userStackView = hStack(vStack(iconImageView, usernameLabel, alignment: .center, spacing: 8), alignment: .center)
        let overallStackView = hStack(
            backButton,
            userStackView,
            flagButton, distribution: .fill)
        
        //adding some margins to stack view
        overallStackView.isLayoutMarginsRelativeArrangement = true
        overallStackView.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        //image view dimensions
        iconImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: imageHeight, height: imageHeight))
    }
    
    fileprivate func setupViewWithData() {
        usernameLabel.text = match.name
        iconImageView.sd_setImage(with: URL(string: match.profileImageURL), completed: nil)
    }
}
