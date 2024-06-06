//
//  UIViewController+Extension.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-09.
//

import UIKit

extension UIViewController {
    // Get the identifier string for the view controller class.
    static var identifier: String {
        return String(describing: self)
    }
    
    // Instantiate a view controller from the Main storyboard.
    // Returns an instance of the view controller.
    static func instantiate() -> Self {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(identifier: identifier) as! Self
    }
}
