//
//  AdminHomePageVC.swift
//  a4_ngshah3
//
//  Created by Nishit Shah on 2024-04-07.
//

import UIKit

class AdminHomePageVC: UIViewController {

    @IBOutlet var myTabel: UITableView!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users = CoreDataHandler.shared.fetchData().filter { $0.id == 1 }
        myTabel.reloadData()
        
        myTabel.tableFooterView = UIView(frame: .zero)
    }
    
    @IBAction func logOut(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "LoginScreen") as? MainVC {
            // Hide the back button
            vc.navigationItem.setHidesBackButton(true, animated: false)
            
            // Push the view controller onto the navigation stack
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
        
}

extension AdminHomePageVC:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTabel.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        let user = users[indexPath.row]
        cell.nameLabel.text = user.name
        cell.phoneLabel.text = "\(user.phone)"
        cell.cityLabel.text = user.address_city
        
        // Set status text and background color based on status value
        switch user.status {
        case 1:
            cell.statusLabel.text = "AWAITED"
            cell.backgroundColor = UIColor.yellow.withAlphaComponent(0.3) // Yellow Tone
        case 2:
            cell.statusLabel.text = "FAILEDTOREACH"
            cell.backgroundColor = UIColor.red.withAlphaComponent(0.3) // Light Red Tone
        case 3:
            cell.statusLabel.text = "ONBOARDED"
            cell.backgroundColor = UIColor.green.withAlphaComponent(0.3) // Light Green Tone
        case 4:
            cell.statusLabel.text = "INPROCESS"
            cell.backgroundColor = UIColor.green.withAlphaComponent(0.5) // Mid Green Tone
        case 5:
            cell.statusLabel.text = "COMPLETED"
            cell.backgroundColor = UIColor.green.withAlphaComponent(0.7) // Dark Green Tone
        case 6:
            cell.statusLabel.text = "DENIED"
            cell.backgroundColor = UIColor.red // RED Tone
        default:
            cell.statusLabel.text = "UNKNOWN"
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        if let vc = storyboard?.instantiateViewController(identifier: "UserDetails") as? UserDetails {
            vc.userName = user.username ?? ""
            vc.navigationItem.setHidesBackButton(true, animated: false)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                let userToDelete = users[indexPath.row]
                
                // Create and present confirmation alert
                let confirmationAlert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this user?", preferredStyle: .alert)
                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                    // Delete the user from Core Data
                    CoreDataHandler.shared.deleteData(for: userToDelete) {
                        // Once deletion is complete, update the local users array and reload the table view
                        self.users.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                confirmationAlert.addAction(deleteAction)
                confirmationAlert.addAction(cancelAction)
                present(confirmationAlert, animated: true, completion: nil)
            }
    }
}
