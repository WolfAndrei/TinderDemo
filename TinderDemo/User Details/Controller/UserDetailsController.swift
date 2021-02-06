//
//  UserDetailsController.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 27.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import SDWebImage

class UserDetailsController: UIViewController, UIScrollViewDelegate {
    
    //MARK: - CONSTANTS && VARIABLES
    
    fileprivate let extraHeight: CGFloat = 80
    
    var cardVM: CardViewModel? {
        didSet {
            if let cardVM = cardVM {
                infoLabel.attributedText = cardVM.attributedString
                infoLabel.textColor = .black
                
                swipingPhotosController.cardViewModel = cardVM
            }
        }
    }
    
    //MARK: - INITIALIZATION
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBlurEffect()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let imageView = swipingPhotosController.view!
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraHeight)
    }
    
    //MARK: - UI ELEMENTS
    
    let swipingPhotosController = SwipingPhotosController(isCardViewMode: false)
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    let infoLabel:  UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    lazy var dismissalButton = self.createButton(with: #imageLiteral(resourceName: "dismiss_down_arrow"), selector: #selector(handleDismiss))
    lazy var cancelButton = self.createButton(with: #imageLiteral(resourceName: "dismiss_circle"), selector: #selector(handleDislike))
    lazy var starButton = self.createButton(with: #imageLiteral(resourceName: "super_like_circle"), selector: #selector(handleDislike))
    lazy var likeButton = self.createButton(with: #imageLiteral(resourceName: "like_circle"), selector: #selector(handleDislike))
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [cancelButton, starButton, likeButton])
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = -30
        return sv
    }()
    
    //MARK: - USER INTERACTIONS
    
    @objc func handleDislike() {
    }

    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: - DEFAULT METHODS
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = -scrollView.contentOffset.y
        let width = max(view.frame.width + 2 * yOffset, view.frame.width)
        let imageView = swipingPhotosController.view!
        imageView.frame = CGRect(x: min(0, -yOffset), y: min(0, -yOffset), width: width, height: width + extraHeight)
    }
    
    //MARK: - CUSTOM METHODS
    
    fileprivate func createButton(with image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFill
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    
    fileprivate func setupBlurEffect() {
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    
    fileprivate func setupLayout() {
        
        let imageView = swipingPhotosController.view!
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        scrollView.addSubview(imageView)
        scrollView.addSubview(dismissalButton)
        
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.width + extraHeight)
        
        dismissalButton.anchor(top: nil, leading: nil, bottom: imageView.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: 0, left: 0, bottom: -25, right: 24), size: .init(width: 50, height: 50))
        
        scrollView.addSubview(infoLabel)
        infoLabel.anchor(top: imageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: nil, size: CGSize(width: 300, height: 80))
    }
}
