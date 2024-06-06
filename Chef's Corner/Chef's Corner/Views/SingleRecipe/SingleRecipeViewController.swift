//
//  SingleRecipeViewController.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-09.
//

import UIKit

class SingleRecipeViewController: UIViewController {
    
    
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeIngredients: UILabel!
    @IBOutlet weak var recipePreperation: UILabel!
    
    var recipe: Recipe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateView()
    }
    
    // Populate view with recipe data.
    private func populateView (){
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
        
        recipeTitle.text = recipe.title
        recipeIngredients.text = recipe.ingredients
        recipePreperation.text = recipe.preparation
    }
}
