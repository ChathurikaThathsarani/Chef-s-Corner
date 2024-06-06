//
//  CardView.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-04.
//

import Foundation
import UIKit

class CardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        cardBackground()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        cardBackground()
    }
    
    // Configure card background with shadow.
    private func cardBackground() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.cornerRadius = 10
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 10
        cornerRadius = 10
    }
}
