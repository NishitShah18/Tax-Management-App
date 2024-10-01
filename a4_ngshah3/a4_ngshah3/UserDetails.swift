//
//  UserDetails.swift
//  a4_ngshah3
//
//  Created by Nishit Shah on 2024-04-07.
//

import UIKit
import CoreLocation
import MapKit

class UserDetails: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    // Define status options
    let statusOptions = ["AWAITED", "FAILEDTOREACH", "ONBOARDED", "INPROCESS", "COMPLETED", "DENIED"]

    var userName = ""
    var currentUser: User?

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var websiteTextFiled: UITextField!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var statusPickerView: UIPickerView!
    @IBOutlet var statusView: UIView!
    @IBOutlet var statusViewLabel: UILabel!
    
    @IBOutlet var mapKitView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.isUserInteractionEnabled = false
        usernameTextField.isUserInteractionEnabled = false
        passwordTextField.isUserInteractionEnabled = false
        passwordTextField.isSecureTextEntry = true
        phoneTextField.isUserInteractionEnabled = false
        websiteTextFiled.isUserInteractionEnabled = false
        
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
            statusViewLabel.backgroundColor = UIColor.clear
            switch user.status {
            case 1:
                statusViewLabel.text = "AWAITED"
            case 2:
                statusViewLabel.text = "FAILEDTOREACH"
            case 3:
                statusViewLabel.text = "ONBOARDED"
            case 4:
                statusViewLabel.text = "INPROCESS"
            case 5:
                statusViewLabel.text = "COMPLETED"
            case 6:
                statusViewLabel.text = "DENIED"
            default:
                statusViewLabel.text = "UNKNOWN"
            }
            
            // Pre-select the status in the picker view
            let selectedRow = Int(user.status) - 1
            print("Selected row: \(selectedRow)")
            statusPickerView.selectRow(selectedRow, inComponent: 0, animated: false)
            
            statusPickerView.reloadAllComponents()

            // Change background color based on status
            statusView.backgroundColor = getStatusColor(for: Int(user.status))
            displayLocation(for: user)
        }
        
        // Set picker view delegate and data source
        statusPickerView.delegate = self
        statusPickerView.dataSource = self
    }
    
    @IBAction func updateUser(_ sender: Any) {
        // Get selected status from picker view
        let selectedRow = statusPickerView.selectedRow(inComponent: 0)
        
        // Update the user's status attribute
        currentUser?.status = Int64(selectedRow + 1)
        
        // Save the changes to Core Data
        CoreDataHandler.shared.updateProcess(user: currentUser!, password: passwordTextField.text ?? "", status: currentUser?.status ?? 0) {
            // Handle completion if needed
        }
        
        // Change background color based on selected status
        statusView.backgroundColor = getStatusColor(for: selectedRow + 1)
        
        switch currentUser?.status {
        case 1:
            statusViewLabel.text = "AWAITED"
            statusViewLabel.backgroundColor = getStatusColor(for: selectedRow + 1)
        case 2:
            statusViewLabel.text = "FAILEDTOREACH"
            statusViewLabel.backgroundColor = getStatusColor(for: selectedRow + 1)
        case 3:
            statusViewLabel.text = "ONBOARDED"
            statusViewLabel.backgroundColor = getStatusColor(for: selectedRow + 1)
        case 4:
            statusViewLabel.text = "INPROCESS"
            statusViewLabel.backgroundColor = getStatusColor(for: selectedRow + 1)
        case 5:
            statusViewLabel.text = "COMPLETED"
            statusViewLabel.backgroundColor = getStatusColor(for: selectedRow + 1)
        case 6:
            statusViewLabel.text = "DENIED"
            statusViewLabel.backgroundColor = getStatusColor(for: selectedRow + 1)
        default:
            statusViewLabel.text = "UNKNOWN"
        }
        
    }

    // Helper function to get color based on status
    private func getStatusColor(for status: Int) -> UIColor {
        switch status {
        case 1: return UIColor.yellow.withAlphaComponent(0.3) // Yellow Tone
        case 2: return UIColor.red.withAlphaComponent(0.3) // Light Red Tone
        case 3: return UIColor.green.withAlphaComponent(0.3) // Light Green Tone
        case 4: return UIColor.green.withAlphaComponent(0.5) // Mid Green Tone
        case 5: return UIColor.green.withAlphaComponent(0.7) // Dark Green Tone
        case 6: return UIColor.red // RED Tone
        default: return UIColor.white
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statusOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statusOptions[row]
    }
    
    func displayLocation(for user: User) {
        // Combine address components to create a full address string
        let addressString = "\(user.address_street ?? ""), \(user.address_city ?? ""), \(user.address_zipcode ?? "")"
        
        // Initialize a CLGeocoder instance to convert address to coordinates
        let geocoder = CLGeocoder()
        
        // Perform geocoding to get the coordinates
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            guard let placemark = placemarks?.first, let location = placemark.location else {
                print("Error finding location: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Create a map annotation for the user's location
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = user.name
            
            // Add the annotation to the map
            self.mapKitView.addAnnotation(annotation)
            
            // Zoom the map to the user's location
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            self.mapKitView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(identifier: "AdminHomePage") as? AdminHomePageVC {
            // Hide the back button
            vc.navigationItem.setHidesBackButton(true, animated: false)
            
            // Push the view controller onto the navigation stack
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
