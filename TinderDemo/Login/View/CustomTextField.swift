//
//  CustomTextField.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 24.07.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
   
     init(padding: CGFloat, intrinsicSize: CGSize) {
         self.padding = padding
         self.intrinsicSize = intrinsicSize
         super.init(frame: .zero)
     }
     
     required init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     let padding: CGFloat
     let intrinsicSize: CGSize
     
     override var intrinsicContentSize: CGSize {
         return intrinsicSize
     }
     override func textRect(forBounds bounds: CGRect) -> CGRect {
         return bounds.insetBy(dx: padding, dy: 0)
     }
     override func editingRect(forBounds bounds: CGRect) -> CGRect {
         return bounds.insetBy(dx: padding, dy: 0)
     }

}
