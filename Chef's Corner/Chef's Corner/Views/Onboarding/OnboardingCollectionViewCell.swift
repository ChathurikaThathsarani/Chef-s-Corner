//
//  OnboardingCollectionViewCell.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-01.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: OnboardingCollectionViewCell.self)
    
    @IBOutlet weak var slideImage: UIImageView!
    @IBOutlet weak var slideDescription: UILabel!
    @IBOutlet weak var slideTitle: UILabel!
    
    func slideSetup(_ slide: OnboardingObject){
        slideImage.image = slide.image
        slideTitle.text = slide.title
        slideDescription.text = slide.description
    }
}
