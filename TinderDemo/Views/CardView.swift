//
//  CardView.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 23.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class CardView: UIView, CAAnimationDelegate {
    
    
    var user: User? {
        didSet {
            if let user = user {
                imageView.image = UIImage(named: user.photoName)
                label.attributedText = addAttributedText()
            }
        }
    }
    
    
    fileprivate func addAttributedText() -> NSMutableAttributedString? {
        
        if let user = user {
            let nameAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 30, weight: .bold), .foregroundColor : UIColor.white]
            let ageAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 25, weight: .thin), .foregroundColor : UIColor.white]
            let professionAttributes: [NSAttributedString.Key : Any] = [.font: UIFont.systemFont(ofSize: 20, weight: .regular), .foregroundColor : UIColor.white]
            
            let attributedText = NSMutableAttributedString(string: user.name, attributes: nameAttributes)
            attributedText.append(NSAttributedString(string: " \(user.age)\n", attributes: ageAttributes))
            attributedText.append(NSAttributedString(string: user.profession, attributes: professionAttributes))
                       
            return attributedText
        }
        return nil
        
    }
    
    lazy var gradientLayer: CAGradientLayer = {
        
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear, UIColor(white: 0, alpha: 0.8)].map{$0.cgColor}
        layer.locations = [0.7, 1].map{NSNumber(floatLiteral: $0)}
        return layer
    }()
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        imageView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = imageView.bounds
    }
    
    lazy var imageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    
    fileprivate let minimumOffsetForDismissing: CGFloat = 200
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let targetSize = CGSize(width: 1000, height: 1000)
        let estimatedSize = label.systemLayoutSizeFitting(targetSize)
       
        addSubview(imageView)
        imageView.addSubview(label)
        imageView.fillSuperview()
        label.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 0), size: estimatedSize)
        
       
        
        layer.cornerRadius = 10
        clipsToBounds = true
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(pan)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        let Xtransl = translation.x
        let Ytransl = translation.y
        switch gestureRecognizer.state {
        case .changed:
            handleGestureTranslation(Xtransl, Ytransl)
        case .ended:        fallthrough
        case .cancelled:    fallthrough
        case .failed:
            dismissalAnimation(Xtransl)
        default:
            ()
        }
    }
    
    fileprivate func handleGestureTranslation(_ Xtransl: CGFloat,_ Ytransl: CGFloat) {
        layer.transform = CATransform3DConcat(
            CATransform3DMakeRotation((Xtransl / 20).convertPIinDegree(), 0, 0, 1),
            CATransform3DMakeTranslation(Xtransl, Ytransl, 0))
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }
    
    
    fileprivate func dismissalAnimation(_ Xtransl: CGFloat) {
        let shouldDismissCard = abs(Xtransl) > minimumOffsetForDismissing
        let translationDirection: CGFloat = (Xtransl > 0) ? 1.0 : -1.0
        CATransaction.begin()
        let anim = CASpringAnimation(keyPath: "transform")
        
        anim.toValue = shouldDismissCard ?
            NSValue(caTransform3D: CATransform3DMakeTranslation(translationDirection * 600, 0, 0)) :
            NSValue(caTransform3D: CATransform3DIdentity)
        
        anim.damping = 25
        anim.mass = 1.1
        anim.initialVelocity = 0.2
        anim.stiffness = 150
        anim.duration = anim.settlingDuration
        anim.timingFunction = CAMediaTimingFunction(name: .easeOut)
//        anim.fillMode = .forwards
//        anim.isRemovedOnCompletion = false
        CATransaction.setCompletionBlock {
            self.layer.transform = CATransform3DIdentity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
            self.layer.shouldRasterize = false
        }
        layer.add(anim, forKey: "translation")
        CATransaction.commit()
    }
    
    

}
