//
//  GradientButton.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 29.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class GradientButton: UIButton {
    
    init(colors: [UIColor], isGradientBorder: Bool, borderWidth: CGFloat? = 0) {
        self.colors = colors
        self.isGradientBorder = isGradientBorder
        self.borderWidth = borderWidth
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var isGradientBorder: Bool
    var colors: [UIColor]
    var borderWidth: CGFloat?
    lazy var gradientLayer: CAGradientLayer = {
        let grLayer = CAGradientLayer()
        grLayer.colors = colors.map{$0.cgColor}
        grLayer.startPoint = CGPoint(x: 0.5, y: 0)
        grLayer.endPoint = CGPoint(x: 1, y: 0)
        return grLayer
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        gradientLayer.frame = bounds
        
        if isGradientBorder {
            setupMask()
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    fileprivate func setupButton() {
        layer.masksToBounds = true
    }
    
    fileprivate func setupMask() {
        let maskLayer = CAShapeLayer()
        gradientLayer.mask = maskLayer
        maskLayer.fillRule = .evenOdd
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2)
        path.append(UIBezierPath(roundedRect: bounds.insetBy(dx: 2, dy: 2), cornerRadius: bounds.insetBy(dx: borderWidth!, dy: borderWidth!).height / 2))
        maskLayer.path = path.cgPath
    }
    
}
