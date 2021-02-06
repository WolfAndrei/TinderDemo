//
//  Extensions+UIAlertController.swift
//  TinderDemo
//
//  Created by Andrei Volkau on 04.09.2020.
//  Copyright © 2020 Andrei Volkau. All rights reserved.
//

import UIKit

//BUG FIX OF UNRELATABLE CONSTRAINT FOR ALERT CONTROLLER
extension UIAlertController {
    func pruneNegativeWidthConstraints() {
        for subView in self.view.subviews {
            for constraint in subView.constraints where constraint.debugDescription.contains("width == - 16") {
                subView.removeConstraint(constraint)
            }
        }
    }
}
