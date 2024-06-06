//
//  CreateRecipeViewController.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-09.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class CreateRecipeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var timeToCook: UITextField!
    @IBOutlet weak var timeToPrep: UITextField!
    @IBOutlet weak var ingredients: UITextView!
    @IBOutlet weak var preparation: UITextView!
    
   // Action method to save the recipe.
    @IBAction func saveRecipe(_ sender: UIButton) {
        // Validation of input fields
        guard let recipeTitle = recipeName.text, !recipeTitle.isEmpty,
              let recipeIngredients = ingredients.text, !recipeIngredients.isEmpty,
              let recipePreparation = preparation.text, !recipePreparation.isEmpty,
              let cookTime = timeToCook.text, !cookTime.isEmpty,
              let prepTime = timeToPrep.text, !prepTime.isEmpty,
              let recipeImage = recipeImage.image else {
            self.showAlert(title: "Error", message: "All fields must be filled")
            print("Error: All fields must be filled")
            return
        }
        
        // Proceed with saving the recipe to Firebase
        uploadImageToFirebaseStorage(image: recipeImage) { [weak self] imageURL in
            guard let self = self, let imageURL = imageURL else {
                self!.showAlert(title: "Error", message: "Failed to upload image to Firebase")
                print("Error: Failed to upload image to Firebase")
                return
            }
            
            var userId: String = ""
            var special: Bool = false
            
            if let Id = UserDefaults.standard.string(forKey: "userId"), let isAdmin = UserDefaults.standard.string(forKey: "isAdmin") {
                userId = Id
                if(isAdmin == "1"){
                    special = true
                } else {
                    special = false
                }
            } else {
                print("User ID not found in UserDefaults")
            }
            
            let recipe = Recipe(id: userId, title: recipeTitle, ingredients: recipeIngredients, preparation: recipePreparation, toCook: cookTime + " minutes", toPrep: prepTime + " minutes", special: special, image: imageURL)
            self.saveRecipeToFirestore(recipe: recipe)
        }
    }
    
    
    // Upload the recipe image to Firebase storage.
    func uploadImageToFirebaseStorage(image: UIImage, completion: @escaping (URL?) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(nil)
            return
        }
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading image: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: error.localizedDescription)
                completion(nil)
                return
            }
            imageRef.downloadURL { url, error in
                if let error = error {
                    print("Error getting download URL: \(error.localizedDescription)")
                    self.showAlert(title: "Error", message: error.localizedDescription)
                    completion(nil)
                    return
                }
                completion(url)
            }
        }
    }
    
    // Save the recipe data to Firestore.
    func saveRecipeToFirestore(recipe: Recipe) {
        let db = Firestore.firestore()
        let recipeData = recipe.toDictionary()
        db.collection("recipes").addDocument(data: recipeData) { error in
            if let error = error {
                print("Error adding document: \(error.localizedDescription)")
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                print("Recipe added successfully!")
                let controller = self.storyboard?.instantiateViewController(identifier: "homeVC") as! UINavigationController
                controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .flipHorizontal
                self.present(controller, animated: true, completion: nil)
                self.showAlert(title: "Success", message: "Recipe added successfully")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapgasture()
    }
    
    
    // Function to add tap gesture recognizer to recipeImage
    func tapgasture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        recipeImage.isUserInteractionEnabled = true
        recipeImage.addGestureRecognizer(tap)
    }
    // Selector method called when recipeImage is tapped
    @objc func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate method called when user picks an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            recipeImage.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Alert function
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
