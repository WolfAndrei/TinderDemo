//
//  CircleCell.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 30.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit
import SDWebImage

class CircleCell: GenericCell<Match> {

    //MARK: - CONSTANTS && VARIABLESs
    
    override var item: Match! {
        didSet {
            usernameLabel.text = item.name
            imageView.sd_setImage(with: URL(string: item.profileImageURL), completed: nil)
        }
    }
    
    //MARK: - UI ELEMENTS
    
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = #imageLiteral(resourceName: "jane3")
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let usernameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.text = "Username here"
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    //MARK: - DEFAULT METHODS
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = imageView.bounds.height / 2
    }
    
    //MARK: - CUSTOM METHODS
    
    override func setupLayout() {
        super.setupLayout()
        
        addSubview(imageView)
        addSubview(usernameLabel)
        
        imageView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 0), size: .init(width: 80, height: 80))
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        usernameLabel.anchor(top: imageView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
}
