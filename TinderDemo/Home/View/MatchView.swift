//
//  MatchView.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 29.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class MatchView: UIView {
    
    var currentUser: User?
    
    var cardUID: String? {
        didSet {
            if let cardUID = cardUID {
                
                let dbRef = Firestore.firestore().collection("users")
                
                dbRef.document(cardUID).getDocument { (docSnapshot, error) in
                    if let error = error {
                        print("Failed to retrieve the user card", error)
                        return
                    }
                    guard let dictionary = docSnapshot?.data() else {return}
                    let user = User(userDictionary: dictionary)
                    
                    guard let url = URL(string: user.image1Url ?? "") else {return}
                    self.matchedUserImageView.sd_setImage(with: url, completed: nil)
                    
                    guard let currentUserURL = URL(string: self.currentUser?.image1Url ?? "") else {return}
                    self.currentUserImageView.sd_setImage(with: currentUserURL) { (_, _, _, _) in
                        self.setupAnimations()
                    }
                    self.descriptionLabel.text = "You and \(user.name ?? "") have liked each other"
                }
            }
        }
    }
    
    
    fileprivate let itsAMatchImageView: UIImageView = {
        let iv  = UIImageView()
        iv.image = #imageLiteral(resourceName: "itsamatch")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    fileprivate let descriptionLabel: UILabel = {
        let label  = UILabel()
        label.text = "You and Lulu have liked each other"
        label.textAlignment = .center
        label.textColor = .white
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        return label
       }()
       
    
    
    fileprivate let currentUserImageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "jane3")
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
    }()
    
    
    fileprivate let matchedUserImageView: UIImageView = {
          let iv = UIImageView()
           iv.contentMode = .scaleAspectFill
           iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.alpha = 0
           return iv
       }()
    
    let sendMessageButton: GradientButton = {
        let button = GradientButton(colors: [#colorLiteral(red: 0.9552921661, green: 0.2195528642, blue: 0.4659050471, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.4799057469, blue: 0.3013980905, alpha: 1)], isGradientBorder: false)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14)
        return button
    }()
    
    let keepSwiping: GradientButton = {
       let button = GradientButton(colors: [#colorLiteral(red: 0.9552921661, green: 0.2195528642, blue: 0.4659050471, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.4799057469, blue: 0.3013980905, alpha: 1)], isGradientBorder: true, borderWidth: 2)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12)
        button.addTarget(self, action: #selector(handleKeepSwiping), for: .touchUpInside)
        return button
    }()
    
    @objc func handleKeepSwiping() {
        print("Pressed")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlurView()
        setupLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var views = [
        currentUserImageView,
        matchedUserImageView,
        itsAMatchImageView,
        descriptionLabel,
        sendMessageButton,
        keepSwiping
    ]
    fileprivate func setupLayout() {
        
        views.forEach{
            addSubview($0)
            $0.alpha = 0
        }
        
        currentUserImageView.anchor(top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 20), size: .init(width: 140, height: 140))
        currentUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        matchedUserImageView.anchor(top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 0), size: .init(width: 140, height: 140))
        matchedUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
     
        descriptionLabel.anchor(top: nil, leading: leadingAnchor, bottom: currentUserImageView.topAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 30, right: 0), size: .init(width: 0, height: 50))
        
        itsAMatchImageView.anchor(top: nil, leading: nil, bottom: descriptionLabel.topAnchor, trailing: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 0), size: .init(width: 300, height: 80))
        itsAMatchImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 32, left: 50, bottom: 0, right: 50), size: .init(width: 0, height: 50))
        
        keepSwiping.anchor(top: sendMessageButton.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 16, left: 50, bottom: 0, right: 50), size: .init(width: 0, height: 50))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        currentUserImageView.layer.cornerRadius = currentUserImageView.bounds.height / 2
        matchedUserImageView.layer.cornerRadius = matchedUserImageView.bounds.height / 2
    }
    
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    fileprivate func setupAnimations() {
        self.views.forEach{$0.alpha = 1}
        
        let angle: CGFloat = 30

        currentUserImageView.layer.transform = CATransform3DConcat(CATransform3DMakeRotation(-angle.convertPIinDegree(), 0, 0, 1), CATransform3DMakeTranslation(200, 0, 0))
        matchedUserImageView.layer.transform = CATransform3DConcat(CATransform3DMakeRotation(angle.convertPIinDegree(), 0, 0, 1), CATransform3DMakeTranslation(-200, 0, 0))
        
        sendMessageButton.transform = CGAffineTransform(translationX: 500, y: 0)
        keepSwiping.transform = CGAffineTransform(translationX: -500, y: 0)
        
        CATransaction.begin()
        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.toValue = 0
        animation.duration = 0.7
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        let animationRotation = CABasicAnimation(keyPath: "transform.rotation.z")
        animationRotation.toValue = 0
        animationRotation.beginTime = CACurrentMediaTime() + animation.duration
        animationRotation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animationRotation.duration = 0.5
        animationRotation.fillMode = .forwards
        animationRotation.isRemovedOnCompletion = false
        
        
        
        CATransaction.setCompletionBlock {
            self.currentUserImageView.layer.transform = CATransform3DIdentity
            self.matchedUserImageView.layer.transform = CATransform3DIdentity
            
            self.currentUserImageView.layer.removeAllAnimations()
            self.matchedUserImageView.layer.removeAllAnimations()
            
        }
        currentUserImageView.layer.add(animation, forKey: nil)
        currentUserImageView.layer.add(animationRotation, forKey: nil)
        matchedUserImageView.layer.add(animation, forKey: nil)
        matchedUserImageView.layer.add(animationRotation, forKey: nil)
        
       
        
        CATransaction.commit()
        
        
        UIView.animate(withDuration: 0.8, delay: animation.duration, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.sendMessageButton.transform = CGAffineTransform.identity
            self.keepSwiping.transform = CGAffineTransform.identity
        }) { (_) in
            //
        }
    }
    
    
    
    
    fileprivate func setupBlurView() {
        
        blurView.alpha = 0
        self.addSubview(blurView)
        blurView.fillSuperview()
        
        blurView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
            self.blurView.alpha = 1
        }, completion: nil)
        
    }
    
    @objc func handleDismiss() {
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.alpha = 0
        }, completion: { (_) in
            self.removeFromSuperview()
        })
        
    }
    
}
