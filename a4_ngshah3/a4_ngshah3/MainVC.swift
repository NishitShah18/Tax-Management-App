//
//  MainVC.swift
//  a4_ngshah3
//
//  Nishit Shah
//
//  Created by Nishit Shah on 2024-04-07.
//

import UIKit

class MainVC: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "RegistrationScreen") as? RegistrationVC {
            // Hide the back button
            vc.navigationItem.setHidesBackButton(true, animated: false)
            
            // Push the view controller onto the navigation stack
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func loginBtn(_ sender: Any) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
                // Handle invalid input
                return
            }

            // Fetch users with the provided username
            let users = CoreDataHandler.shared.fetchData().filter { $0.username == username }

            if let user = users.first, user.password == password {
                // Username and password match
                if user.id == 1 {
                    // Redirect to User Home Screen
                    if let vc = storyboard?.instantiateViewController(identifier: "UserHomeScreen") as? UserHomePageVC {
                        
                        vc.userName = username
                        
                        // Hide the back button
                        vc.navigationItem.setHidesBackButton(true, animated: false)
                        
                        // Push the view controller onto the navigation stack
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else if user.id == 2 {
                    // Redirect to Admin Home Page
                    if let vc = storyboard?.instantiateViewController(identifier: "AdminHomePage") as? AdminHomePageVC {
                        // Hide the back button
                        vc.navigationItem.setHidesBackButton(true, animated: false)
                        
                        // Push the view controller onto the navigation stack
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            } else {
                // No matching user or incorrect password
                let alert = UIAlertController(title: "Error", message: "Invalid username or password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
            }
    }
    
    func printUsernamesAndPasswords() {
        let users = CoreDataHandler.shared.fetchData()

        for user in users {
            if user.id == 1{
                print("Username: \(user.username ?? "N/A"), Password: \(user.password ?? "N/A")")
            }
        }
    }
    
}
