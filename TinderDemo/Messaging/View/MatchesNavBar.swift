//
//  MatchesNavBar.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 29.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class MatchesNavBar: UIView {
    
    //MARK: - INITIALIZATION
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - UI ELEMENTS
    
    fileprivate let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "top_messages_icon")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        iv.heightAnchor.constraint(equalToConstant: 40).isActive = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    fileprivate let messagesLabel: UILabel = {
        let label = UILabel()
        label.text = "Messages"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        return label
    }()
    
    fileprivate let feedLabel: UILabel = {
        let label = UILabel()
        label.text = "Feed"
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .gray
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    fileprivate let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.widthAnchor.constraint(equalToConstant: 0.5).isActive = true
        return view
    }()
    
    //MARK: - CUSTOM METHODS
    
    fileprivate func setupLayout() {
        backgroundColor = .white
        setupShadow(opacity: 0.7, radius: 8, offset: .init(width: 0, height: 10), color: UIColor(white: 0, alpha: 0.3))
        
        
        let stack = vStack(separateView, alignment: .center)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 10, left: 0, bottom: 10, right: 0)
        
        let overallStack = vStack(iconImageView,
                                  hStack(messagesLabel,stack, feedLabel, distribution: .fillProportionally))
        overallStack.isLayoutMarginsRelativeArrangement = true
        overallStack.layoutMargins = .init(top: 23, left: 0, bottom: 0, right: 0)
        
        messagesLabel.widthAnchor.constraint(equalTo: feedLabel.widthAnchor, multiplier: 1).isActive = true
        addSubview(backButton)
        backButton.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: 28, left: 12, bottom: 0, right: 0), size: .init(width: 34, height: 34))
    }
}
