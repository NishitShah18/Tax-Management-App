//
//  UserHomePageVC.swift
//  a4_ngshah3
//
//  Created by Nishit Shah on 2024-04-07.
//

import UIKit

class UserHomePageVC: UIViewController {

    var userName = ""
    var currentUser: User?

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var websiteTextFiled: UITextField!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch user data for the given username
        let users = CoreDataHandler.shared.fetchData().filter { $0.username == userName }
        currentUser = users.first

        // Populate text fields and label with user data
        if let user = currentUser {
            nameTextField.text = user.name
            usernameTextField.text = user.username
            passwordTextField.text = user.password
            phoneTextField.text = "\(user.phone)"
            websiteTextFiled.text = user.website
            emailLabel.text = user.email
            
            switch user.status {
            case 1:
                statusLabel.text = "AWAITED"
                statusLabel.backgroundColor = UIColor.yellow.withAlphaComponent(0.3) // Yellow Tone
            case 2:
                statusLabel.text = "FAILEDTOREACH"
                statusLabel.backgroundColor = UIColor.red.withAlphaComponent(0.3) // Light Red Tone
            case 3:
                statusLabel.text = "ONBOARDED"
                statusLabel.backgroundColor = UIColor.green.withAlphaComponent(0.3) // Light Green Tone
            case 4:
                statusLabel.text = "INPROCESS"
                statusLabel.backgroundColor = UIColor.green.withAlphaComponent(0.5) // Mid Green Tone
            case 5:
                statusLabel.text = "COMPLETED"
                statusLabel.backgroundColor = UIColor.green.withAlphaComponent(0.7) // Dark Green Tone
            case 6:
                statusLabel.text = "DENIED"
                statusLabel.backgroundColor = UIColor.red // RED Tone
            default:
                statusLabel.text = "UNKNOWN"
                statusLabel.backgroundColor = UIColor.white
            }
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "LoginScreen") as? MainVC {
            // Hide the back button
            vc.navigationItem.setHidesBackButton(true, animated: false)
            
            // Push the view controller onto the navigation stack
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func updateUser(_ sender: Any) {
        // Check if currentUser is not nil
            guard let currentUser = currentUser else {
                return
            }

            // Get updated values from text fields
            let name = nameTextField.text ?? ""
            let email = emailLabel.text ?? ""
            let phone = Int64(phoneTextField.text ?? "") ?? 0
            let username = usernameTextField.text ?? ""
            let password = passwordTextField.text ?? ""
            let website = websiteTextFiled.text ?? ""

            // Update user with new data
        CoreDataHandler.shared.update(user: currentUser,
                                           name: name,
                                           username: username,
                                           email: email,
                                           phone: phone,
                                           website: website,
                                           password: password) {
                // Update successful, show alert
                let alert = UIAlertController(title: "Success", message: "User data updated successfully!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
    }
}
