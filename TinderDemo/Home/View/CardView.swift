//
//  CardView.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 23.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapMoreInfo(cardViewModel: CardViewModel)
}

class CardView: UIView, CAAnimationDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        addGestureRecognizer(pan)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = self.bounds
    }
    
    var nextCardView: CardView?
    
    var delegate: CardViewDelegate?
    
    //MARK: - Property to share
    var cardVM: CardViewModel? {
        didSet {
            if let cardVM = cardVM {
                
                swipingPhotosController.cardViewModel = cardVM
                infoLabel.attributedText = cardVM.attributedString
                infoLabel.textAlignment = cardVM.textAlignment
                (0 ..< cardVM.imageURLs.count).forEach {_ in
                    let bar = UIView()
                    bar.layer.cornerRadius = 2
                    bar.clipsToBounds = true
                    bar.backgroundColor = grayColor
                    barStackView.addArrangedSubview(bar)
                }
                barStackView.arrangedSubviews.first?.backgroundColor = .white
                setupImageIndexObserver()
                
            }
        }
    }
    
    fileprivate func setupImageIndexObserver() {
        if let cardVM = cardVM {
            
            cardVM.imageIndexObserver = { [weak self] (index, _) in
                guard let self = self else { return }
                self.barStackView.arrangedSubviews.forEach{$0.backgroundColor = self.grayColor}
                self.barStackView.arrangedSubviews[index].backgroundColor = .white
            }
        }
    }
    
    //MARK: - FilePrivate Properties and Views
    fileprivate let grayColor = UIColor(white: 0, alpha: 0.1)
    fileprivate let minimumOffsetForDismissing: CGFloat = 200
    
    fileprivate let moreInfoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "info_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(handleMoreInfo), for: .touchUpInside)
        return button
    }()
    
    @objc func handleMoreInfo() {
        delegate?.didTapMoreInfo(cardViewModel: self.cardVM!)
    }
    
    fileprivate let gradientLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.clear, UIColor(white: 0, alpha: 0.8)].map{$0.cgColor}
        layer.locations = [0.7, 1].map{NSNumber(floatLiteral: $0)}
        return layer
    }()
    
    fileprivate let swipingPhotosController = SwipingPhotosController(isCardViewMode: true)
    
    fileprivate let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - FilePrivate Methods
    
    fileprivate func setupLayout() {
        
        let targetSize = CGSize(width: 0, height: 1000)
        let estimatedSize = infoLabel.systemLayoutSizeFitting(targetSize)
        
        let swipingPhotosView = swipingPhotosController.view!
        
        addSubview(swipingPhotosView)
        layer.addSublayer(gradientLayer)
        addSubview(infoLabel)
        swipingPhotosView.fillSuperview()
        infoLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16), size: estimatedSize)
        layer.cornerRadius = 10
        clipsToBounds = true
        
        addSubview(moreInfoButton)
        
        moreInfoButton.anchor(top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 16), size: CGSize(width: 44, height: 44))
        
        
    }
    
    
    fileprivate let barStackView = UIStackView()
    
    //MARK: - ANIMATIONS && AND GESTURES
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let tapLocation = gestureRecognizer.location(in: gestureRecognizer.view!.superview!)
        let goNextBack = tapLocation.x > center.x ? true : false
        if let cardVM = cardVM {
            if goNextBack {
                cardVM.advanceToNextPhoto()
            } else {
                cardVM.goToPreviousPhoto()
            }
        }
    }
    
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
        let Xtransl = translation.x
        let Ytransl = translation.y
        switch gestureRecognizer.state {
        case .began:
            superview?.isUserInteractionEnabled = false
            superview?.subviews.forEach{$0.layer.removeAllAnimations()}
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
        
        if shouldDismissCard {
            guard let homeController = self.delegate as? HomeController else {return}
            
            
            if translationDirection == 1 {
                homeController.handleLike()
            } else {
                homeController.handleDislike()
            }
            
        } else {
            
            
            CATransaction.begin()
            let anim = CASpringAnimation(keyPath: "transform")
            
            anim.toValue = NSValue(caTransform3D: CATransform3DIdentity)
            
            anim.damping = 25
            anim.mass = 1.1
            anim.initialVelocity = 0.2
            anim.stiffness = 150
            anim.duration = anim.settlingDuration
            anim.timingFunction = CAMediaTimingFunction(name: .easeOut)
            CATransaction.setCompletionBlock {
                self.layer.transform = CATransform3DIdentity
                self.superview?.isUserInteractionEnabled = true
                self.layer.shouldRasterize = false
            }
            layer.add(anim, forKey: "translation")
            CATransaction.commit()
            
            
            
            
        }
        
        
    }
    
    
    
}
