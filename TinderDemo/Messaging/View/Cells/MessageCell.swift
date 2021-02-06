//
//  MessageCell.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 30.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit


class MessageCell: GenericCell<Message> {
    
    //MARK: - CONSTANTS && VARIABLES
    
    fileprivate var anchoredContraints: AnchoredConstraints!
    fileprivate var textViewConstraints: AnchoredConstraints!
    override var item: Message! {
        didSet {
            textView.text = item.text
            bubbleImage.image = ( item.isMyMessage ? #imageLiteral(resourceName: "bubble_outgoing") : #imageLiteral(resourceName: "bubble")).withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: .init(top: 21, left: 30, bottom: 21, right: 30))
            bubbleImage.tintColor = ( item.isMyMessage ? #colorLiteral(red: 0.1901208758, green: 0.6923189163, blue: 1, alpha: 1) : #colorLiteral(red: 0.8521742821, green: 0.8471090794, blue: 0.8560680747, alpha: 1))
            if item.isMyMessage {
                anchoredContraints.leading?.isActive = false
                anchoredContraints.trailing?.isActive = true
                
                textViewConstraints.leading?.constant = 3
                textViewConstraints.trailing?.constant = -12
            } else {
                anchoredContraints.trailing?.isActive = false
                anchoredContraints.leading?.isActive = true
                textViewConstraints.leading?.constant = 12
                textViewConstraints.trailing?.constant = -3
            }
        }
    }
    
    //MARK: - UI ELEMENTS
    
    fileprivate let bubbleContainer = UIView()
    
    fileprivate let bubbleImage: UIImageView = {
        let bubble = UIImageView()
        bubble.image = #imageLiteral(resourceName: "bubble").withRenderingMode(.alwaysTemplate).resizableImage(withCapInsets: .init(top: 21, left: 30, bottom: 21, right: 30))
        bubble.tintColor = #colorLiteral(red: 0.8521742821, green: 0.8471090794, blue: 0.8560680747, alpha: 1)
        return bubble
    }()
    
    fileprivate let textView: UITextView = {
        let tw = UITextView()
        tw.font = .systemFont(ofSize: 18)
        tw.backgroundColor = .clear
        tw.isUserInteractionEnabled = false
        tw.isScrollEnabled = false
        return tw
    }()
    
    //MARK: - CUSTOM METHODS
    
    override func setupLayout() {
        
        addSubview(bubbleContainer)
        bubbleContainer.addSubview(bubbleImage)
        bubbleContainer.addSubview(textView)
        
        anchoredContraints = bubbleContainer.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        
        anchoredContraints.leading?.constant = 20
        anchoredContraints.trailing?.constant = -20
        anchoredContraints.width = bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250)
        anchoredContraints.width!.isActive = true
        
        bubbleImage.fillSuperview()
        
        textViewConstraints = textView.anchor(top: bubbleContainer.topAnchor, leading: bubbleContainer.leadingAnchor, bottom: bubbleContainer.bottomAnchor, trailing: bubbleContainer.trailingAnchor, padding: .init(top: 4, left: 0, bottom: 4, right: 0))
        
    }
    
}
