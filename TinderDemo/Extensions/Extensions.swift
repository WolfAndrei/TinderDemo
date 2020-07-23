//
//  Extensions.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 22.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstraintsWith(_ format: String, views: UIView...) {
        var viewDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let viewPath = "[v\(index)]"
            viewDictionary[viewPath] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: format, options: [], metrics: nil, views: viewDictionary))
    }
    
    struct AnchoredConstraints {
        var top, leading, bottom, trailing, width, height: NSLayoutConstraint?
    }
    
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) -> AnchoredConstraints {
        
        translatesAutoresizingMaskIntoConstraints = false
        var anchoredConstraints = AnchoredConstraints()
        
        if let top = top {
            anchoredConstraints.top = topAnchor.constraint(equalTo: top, constant: padding.top)
        }
        if let leading = leading {
            anchoredConstraints.leading = leadingAnchor.constraint(equalTo: leading, constant: padding.left)
        }
        if let bottom = bottom {
            anchoredConstraints.bottom = bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom)
        }
        if let trailing = trailing {
            anchoredConstraints.trailing = trailingAnchor.constraint(equalTo: trailing, constant: -padding.right)
        }
        if size.width != 0 {
            anchoredConstraints.width = widthAnchor.constraint(equalToConstant: size.width)
        }
        if size.height != 0 {
            anchoredConstraints.height = heightAnchor.constraint(equalToConstant: size.height)
        }
        [anchoredConstraints.top, anchoredConstraints.leading, anchoredConstraints.bottom, anchoredConstraints.trailing, anchoredConstraints.width, anchoredConstraints.height].forEach{ $0?.isActive = true }
        
        return anchoredConstraints
    }
    
    
    func fillSuperview(padding: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let superviewTopAnchor = superview?.topAnchor {
            topAnchor.constraint(equalTo: superviewTopAnchor, constant: padding.top).isActive = true
        }
        
        if let superviewBottomAnchor = superview?.bottomAnchor {
            bottomAnchor.constraint(equalTo: superviewBottomAnchor, constant: -padding.bottom).isActive = true
        }
        
        if let superviewLeadingAnchor = superview?.leadingAnchor {
            leadingAnchor.constraint(equalTo: superviewLeadingAnchor, constant: padding.left).isActive = true
        }
        
        if let superviewTrailingAnchor = superview?.trailingAnchor {
            trailingAnchor.constraint(equalTo: superviewTrailingAnchor, constant: -padding.right).isActive = true
        }
    }
    
    func centerInSuperview(size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        if let superviewCenterXAnchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: superviewCenterXAnchor).isActive = true
        }
        if let superviewCenterYAnchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: superviewCenterYAnchor).isActive = true
        }
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
}


extension UIColor {
    
    static func rgbWithAlpha(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    
}


extension UITextField {
    func disableAutoFill() {
        if #available(iOS 12, *) {
            textContentType = .oneTimeCode
        } else {
            textContentType = .init(rawValue: "")
        }
    }
}




//BUG FIX OF UNRELATABLE CONSTRAINT FOR ALERT CONTROLLER
extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}

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
            placeholderLabel.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor, padding: UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 4))
            placeholderLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
    }
}



extension Date {
    func timeAgoDisplay() -> String {
       
        if #available(iOS 13, *) {
            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            return formatter.localizedString(for: self, relativeTo: Date())
        }
        else {
            let secondsAgo = Int(Date().timeIntervalSince(self))
            
            let minute = 60
            let hour = minute * 60
            let day = 24 * hour
            let week = 7 * day
            let month = 4 * week
            
            let quotient: Int
            let unit: String
            
            if secondsAgo < minute {
                quotient = secondsAgo
                unit = "second"
            } else if secondsAgo < hour {
                quotient = secondsAgo / minute
                unit = "minute"
            } else if secondsAgo < day {
                quotient = secondsAgo / hour
                unit = "hour"
            } else if secondsAgo < week {
                quotient = secondsAgo / day
                unit = "day"
            } else if secondsAgo < month {
                quotient = secondsAgo / week
                unit = "week"
            } else {
                quotient = secondsAgo / month
                unit = "month"
            }
            
            return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        }
    }
}

class InputAccessoryView: UIView, UITextViewDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if let window = self.window {
                    self.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
            }
        }
    }
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
}


extension CGFloat {
    
    func convertPIinDegree() -> CGFloat {
        return self * .pi / 180
    }
    
    
}

