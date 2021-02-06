//
//  AgeRangeCell.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 27.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class AgeRangeLabel: UILabel {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 80, height: 0)
    }
}


class AgeRangeCell: UITableViewCell {

    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    lazy var minLabel: AgeRangeLabel = {
        let label = AgeRangeLabel()
        label.text = "Min 88"
        return label
    }()
    
    let maxLabel: AgeRangeLabel = {
        let label = AgeRangeLabel()
        label.text = "Max 88"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLabel, minSlider]),
            UIStackView(arrangedSubviews: [maxLabel, maxSlider])])
        
        self.addSubview(stackView)
        stackView.fillSuperview(padding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
    }
    
    
    
    
    
}
