//
//  LoginViewController.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-03.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    
    var firestore: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firestore = Firestore.firestore()
    }
    
    // Login action
    @IBAction func loginButton(_ sender: UIButton) {
        guard let email = loginEmail.text, let password = loginPassword.text else {
            self.showAlert(title: "Error", message: "Please fill all the fields")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                self.showAlert(title: "Error", message: e.localizedDescription)
            } else {
                
                if let user = authResult?.user {
                    let userId = user.uid
                    UserDefaults.standard.set(userId, forKey: "userId")
                    self.fetchUserDataAndSaveToUserDefaults(userId: userId)
                    
                    let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! UINavigationController
                    homeVC.modalPresentationStyle = .fullScreen
                    homeVC.modalTransitionStyle = .flipHorizontal
                    self.present(homeVC, animated: true) {
                        self.showAlert(title: "Success", message: "Successfully logged in")
                    }
                } else {
                    self.showAlert(title: "Error", message: "User data not available")
                }
            }
        }
    }
    
    // Save user defaults
    func fetchUserDataAndSaveToUserDefaults(userId: String) {
        firestore.collection("users").whereField("userId", isEqualTo: userId).limit(to: 1)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error fetching user data: \(error.localizedDescription)")
                    return
                }
                
                guard let document = querySnapshot?.documents.first else {
                    print("No user data found")
                    return
                }
                
                // Retrieve user data from the first document
                let userData = document.data()
                
                // Check if isAdmin field exists in the user data
                if let isAdmin = userData["admin"] as? Bool {
                    // Save isAdmin value to UserDefaults
                    UserDefaults.standard.set(isAdmin, forKey: "isAdmin")
                    
                    print("isAdmin value fetched and saved to UserDefaults")
                } else {
                    print("isAdmin field not found in user data")
                }
            }
    }
    
    // Alert function
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
