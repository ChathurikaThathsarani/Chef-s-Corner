//
//  RecipeListViewController.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-09.
//

import UIKit
import Firebase

class RecipeListViewController: UIViewController {
    
    
    @IBOutlet weak var recipeList: UITableView!
    var firestore: Firestore!
    var recipes : [Recipe] = []
    var category: RecipeCategory!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firestore = Firestore.firestore()
        title = category.name
        loadRecipes()
        registerCells()
        recipeList.delegate = self
        recipeList.dataSource = self
    }
    
    private func registerCells() {
        recipeList.register(UINib(nibName: RecipeTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RecipeTableViewCell.identifier)
    }
    
    // Load recipes from Firestore.
    func loadRecipes() {
        firestore.collection("recipes")
            .whereField("special", isEqualTo: true)
            .whereField("category", isEqualTo: category.name)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching recipe: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No recipes")
                    return
                }
                
                self.recipes = documents.compactMap { document in
                    let data = document.data()
                    let id = document.documentID
                    let name = data["title"] as? String ?? ""
                    let imageURLString = data["image"] as? String ?? ""
                    let imageURL = URL(string: imageURLString)
                    
                    let ingredients = data["ingredients"] as? String ?? ""
                    let preparation = data["preparation"] as? String ?? ""
                    let toCook = data["toCook"] as? String ?? ""
                    let toPrep = data["toPrep"] as? String ?? ""
                    let special = data["special"] as? Bool ?? false
                    
                    return Recipe(id: id, title: name, ingredients: ingredients, preparation: preparation, toCook: toCook, toPrep: toPrep, special: special, image: imageURL)
                }
                
                DispatchQueue.main.async {
                    self.recipeList.reloadData()
                }
            }
    }
    
}

// Table View Delegate and Data Source Methods
extension RecipeListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecipeTableViewCell.identifier) as! RecipeTableViewCell
        cell.setup(listRecipe: recipes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = SingleRecipeViewController.instantiate()
        controller.recipe = recipes[indexPath.row]
        navigationController?.pushViewController(controller, animated: true)
    }
}
