//
//  UIView+Extensions.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-01.
//

import Foundation
import UIKit

extension UIView {
    // Corner radius of the view.
    @IBInspectable var cornerRadius : CGFloat {
        get {return cornerRadius}
        set {
            self.layer.cornerRadius = newValue
        }
    }
}
