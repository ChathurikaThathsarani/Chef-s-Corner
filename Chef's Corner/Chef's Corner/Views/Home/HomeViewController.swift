//
//  HomeViewController.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-03.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    @IBOutlet weak var recipeCategoryCollectionView: UICollectionView!
    @IBOutlet weak var populerRecipeCollectionView: UICollectionView!
    @IBOutlet weak var myRecipeCollectionView: UICollectionView!
    
    
    var recipeCategories: [RecipeCategory] = []
    var recipes: [Recipe] = []
    var myRecipes: [Recipe] = []
    var firestore: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firestore = Firestore.firestore()
        loadRecipeCategories()
        loadRecipes()
        registerCells()
        loadMyRecipes()
        
    }
    
    private func registerCells() {
        recipeCategoryCollectionView.register(UINib(nibName: CategoryCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        populerRecipeCollectionView.register(UINib(nibName: PopularRecipeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: PopularRecipeCollectionViewCell.identifier)
        myRecipeCollectionView.register(UINib(nibName: MyRecipeCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: MyRecipeCollectionViewCell.identifier)
    }
    
    // Get recipe categories from firestore
    func loadRecipeCategories() {
        firestore.collection("categories").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching recipe categories: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No recipe categories")
                return
            }
            
            self.recipeCategories = documents.compactMap { document in
                let data = document.data()
                let id = document.documentID
                let name = data["name"] as? String ?? ""
                let imageURLString = data["image"] as? String ?? ""
                let imageURL = URL(string: imageURLString)
                
                return RecipeCategory(id: id, name: name, image: imageURL)
            }
            
            DispatchQueue.main.async {
                self.recipeCategoryCollectionView.reloadData()
            }
        }
    }
    
    // Get recipe from firestore which are uploaded by admin users
    func loadRecipes() {
        firestore.collection("recipes")
            .whereField("special", isEqualTo: true)
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
                    self.populerRecipeCollectionView.reloadData()
                }
            }
    }
    
    // Get personal recipes from firestore
    func loadMyRecipes() {
        var userId: String = ""
        
        if let Id = UserDefaults.standard.string(forKey: "userId") {
            userId = Id
        } else {
            print("User ID not found in UserDefaults")
        }
        firestore.collection("recipes")
            .whereField("special", isEqualTo: false)
            .whereField("id", isEqualTo: userId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching recipe: \(error.localizedDescription)")
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No recipes")
                    return
                }
                
                self.myRecipes = documents.compactMap { document in
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
                    self.myRecipeCollectionView.reloadData()
                }
            }
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case recipeCategoryCollectionView:
            return recipeCategories.count
        case populerRecipeCollectionView:
            return recipes.count
        case myRecipeCollectionView:
            return myRecipes.count
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        case recipeCategoryCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
            cell.setup(category: recipeCategories[indexPath.row])
            return cell
        case populerRecipeCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PopularRecipeCollectionViewCell.identifier, for: indexPath) as! PopularRecipeCollectionViewCell
            cell.setup(recipe: recipes[indexPath.row])
            return cell
        case myRecipeCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyRecipeCollectionViewCell.identifier, for: indexPath) as! MyRecipeCollectionViewCell
            cell.setup(myRecipe: myRecipes[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recipeCategoryCollectionView {
            let controller = RecipeListViewController.instantiate()
            controller.category = recipeCategories[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        } else {
            let controller = SingleRecipeViewController.instantiate()
            controller.recipe = collectionView == populerRecipeCollectionView ? recipes[indexPath.row] : myRecipes[indexPath.row]
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
}


