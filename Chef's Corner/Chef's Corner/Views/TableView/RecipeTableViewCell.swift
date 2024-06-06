//
//  RecipeTableViewCell.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-09.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeToCook: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    
    static let identifier = "RecipeTableViewCell"
    
    // Configure the cell with recipe data.
    func setup(listRecipe: Recipe){
        if let imageURL = listRecipe.image {
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
        recipeToCook.text = listRecipe.toCook
        recipeTitle.text = listRecipe.title
    }
}
