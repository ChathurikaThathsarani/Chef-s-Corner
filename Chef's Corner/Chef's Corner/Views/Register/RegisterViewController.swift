//
//  RegisterViewController.swift
//  Chef's Corner
//
//  Created by Chathurika Dombepola on 2024-04-03.
//

import UIKit
import Firebase


class RegisterViewController: UIViewController {
    
    @IBOutlet weak var registerName: UITextField!
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerConfirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Register action
    @IBAction func registerButton(_ sender: UIButton) {
        guard let name = registerName.text,
              let email = registerEmail.text,
              let password = registerPassword.text,
              let confirmPassword = registerConfirmPassword.text else {
            self.showAlert(title: "Error", message: "Please fill all the fields")
            return
        }
        
        guard password == confirmPassword else {
            self.showAlert(title: "Error", message: "Passwords are not matching")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(title: "Error", message: error.localizedDescription)
            } else {
                if let user = authResult?.user {
                    let userId = user.uid
                    let newUser = User(name: name, email: email, admin: false, userId: userId)
                    saveUserToFirestore(user: newUser)
                    UserDefaults.standard.set(userId, forKey: "userId")
                    UserDefaults.standard.set(false, forKey: "isAdmin")
                    print("User registered successfully")
                } else {
                    print("User data not available")
                }
            }
        }
        
        // Save user to firestore
        func saveUserToFirestore(user: User) {
            let db = Firestore.firestore()
            db.collection("users").addDocument(data: [
                "name": user.name,
                "username": user.email,
                "userId": user.userId,
                "admin": user.admin
            ]) { error in
                if let error = error {
                    self.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    let controller = self.storyboard?.instantiateViewController(identifier: "homeVC") as! UINavigationController
                    controller.modalPresentationStyle = .fullScreen
                    controller.modalTransitionStyle = .flipHorizontal
                    self.present(controller, animated: true, completion: nil)
                    self.showAlert(title: "Success", message: "Successfully registered")
                }
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
