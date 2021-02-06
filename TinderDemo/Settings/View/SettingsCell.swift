//
//  SettingsCell.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 26.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    let textField: CustomTextField = {
       let tf = CustomTextField(padding: 24, intrinsicSize: CGSize(width: 0, height: 44))
        tf.placeholder = "Enter name"
        
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
