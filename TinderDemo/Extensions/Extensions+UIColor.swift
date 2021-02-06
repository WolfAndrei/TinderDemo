//
//  Extensions+UIColor.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 04.09.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgbWithAlpha(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
    
}
