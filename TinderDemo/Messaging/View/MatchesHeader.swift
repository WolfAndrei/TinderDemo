//
//  MatchesHeader.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 03.08.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class MatchesHeader: UICollectionReusableView {
    
    let matchesLabel: UILabel = {
        let label = UILabel()
        label.text = "New Matches"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        return label
    }()
    
    let horizontalViewController = MatchesHorizontalController()
    
    let messagesLabel: UILabel = {
        let label = UILabel()
        label.text = "Messages"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let inStackView = vStack(matchesLabel)
        inStackView.isLayoutMarginsRelativeArrangement = true
        inStackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 0)
        
        let secStackView = vStack(messagesLabel)
        secStackView.isLayoutMarginsRelativeArrangement = true
        secStackView.layoutMargins = .init(top: 0, left: 20, bottom: 0, right: 0)
        
        let stackView = vStack(inStackView, horizontalViewController.view, secStackView, spacing: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

