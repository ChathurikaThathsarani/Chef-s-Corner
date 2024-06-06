//
//  CategoryCollectionViewCell.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-04.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CategoryCollectionViewCell.self)
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureImageViewSize()
    }
    
    // Set up the category cell with the provided category data.
    func setup( category: RecipeCategory){
        if let imageURL = category.image {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.categoryImage.image = image
                        }
                    } else {
                        print("Error: Couldn't create UIImage from data.")
                    }
                } else {
                    print("Error: Couldn't load image data from URL.")
                }
            }
        } else {
            print("Error: Image URL is nil.")
        }
        categoryLabel.text = category.name
        
    }
    
    // Configure the size of the image view.
    private func configureImageViewSize() {
        // Set a fixed size for the image view
        let imageSize = CGSize(width: 100, height: 100) 
        categoryImage.frame.size = imageSize
    }
}
