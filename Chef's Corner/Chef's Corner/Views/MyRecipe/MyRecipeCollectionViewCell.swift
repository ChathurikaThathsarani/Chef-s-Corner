//
//  MyRecipeCollectionViewCell.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-09.
//

import UIKit

class MyRecipeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MyRecipeCollectionViewCell"
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeToCook: UILabel!
    @IBOutlet weak var recipeToPrep: UILabel!
    
    // Setup cell with recipe data.
    func setup(myRecipe:Recipe){
        if let imageURL = myRecipe.image {
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
        recipeToCook.text = "Cook Time: " + myRecipe.toCook
        recipeToPrep.text = "Prep Time: " + myRecipe.toPrep
        recipeTitle.text = myRecipe.title
    }
}
