//
//  PopularRecipeCollectionViewCell.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-08.
//

import UIKit

class PopularRecipeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PopularRecipeCollectionViewCell"
    
    @IBOutlet weak var recipeDescription: UILabel!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    // Setup cell with recipe data.
    func setup(recipe:Recipe){
        if let imageURL = recipe.image {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.recipeImage.image = image
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
        recipeDescription.text = "Prep Time: " + recipe.toCook
        recipeTitle.text = recipe.title
    }
}
