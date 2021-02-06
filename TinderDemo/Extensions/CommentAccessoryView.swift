//
//  ChatTextView.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 30.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

//MARK: - DELEGATE PROTOCOL

protocol CommentInputAccessoryViewDelegate {
    func didPost(for message: String)
}

//MARK: - CLASS

class AdaptiveMultilineAccessoryView: UIView {
    
    //MARK: - CONSTANTS && VARIABLES
    
    fileprivate var heightViewContraint: NSLayoutConstraint?
    fileprivate var heightContraint: NSLayoutConstraint?
    
    var delegate: CommentInputAccessoryViewDelegate?
    
    //MARK: - INITIALIZATION
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: -  UI ELEMENTS
    
    lazy var postButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handlePost), for: .touchUpInside)
        return button
    }()
    
    fileprivate let lineSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .rgbWithAlpha(red: 230, green: 230, blue: 230, alpha: 1)
        return view
    }()
    
    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.font = .systemFont(ofSize: 16)
        tv.placeholder = "Enter message"
        tv.delegate = self
        textViewDidChange(tv)
        tv.textContainerInset = UIEdgeInsets(top: 15, left: 10, bottom: 15, right: 0)
        tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        tv.textAlignment = .left
        return tv
    }()
    
    //MARK: - USER INTERACTIONS
    
    @objc func handlePost() {
        guard let commentText = textView.text else {return}
        delegate?.didPost(for: commentText)
        textView.text = ""
        textViewDidChange(textView)
    }
    
    //MARK: - DEFAULT METHODS

    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    //MARK: - CUSTOM METHODS
    
    func clearCommentTextField() {
        textView.text = nil
    }
    
    fileprivate func setupLayout() {
        
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        
        let stack = hStack(textView, postButton, alignment: .center)
        postButton.anchor(top: nil, leading: nil, bottom: nil, trailing: nil, size: .init(width: 50, height: 50))
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        heightContraint = textView.heightAnchor.constraint(equalToConstant: 50)
        heightContraint?.isActive = true
    }
    
}

//MARK: - EXTENSIONS

extension AdaptiveMultilineAccessoryView: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.viewWithTag(100)?.isHidden = textView.text.isEmpty ? false : true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let maxSize: CGFloat = 120
        let minSize: CGFloat = 50
        heightContraint?.constant = min(maxSize, max(minSize, textView.contentSize.height))

        if let height = heightContraint?.constant {
            guard height < 120 else {return}
            if height > 50 {
                let bottomOffset = CGPoint(x: 0, y: textView.contentSize.height - textView.bounds.size.height)
                textView.setContentOffset(bottomOffset, animated: false)
            }
        }
    }
    
}
