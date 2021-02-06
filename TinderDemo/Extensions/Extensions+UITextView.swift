//
//  Extensions+UITextView.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 04.09.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

//TEXT VIEW PLACEHOLDER
extension UITextView {
    var placeholder: String? {
        get {
            var placeholderText: String?
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderLabel.text = newValue
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    func addPlaceholder(_ text: String) {
        let placeholderLabel = UILabel()
        placeholderLabel.tag = 100
        placeholderLabel.textColor = .lightGray
        placeholderLabel.text = text
        placeholderLabel.font = self.font
        self.addSubview(placeholderLabel)
        placeholderLabel.fillSuperview(padding: .init(top: 0, left: 15, bottom: 0, right: 0))
        placeholderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
}

