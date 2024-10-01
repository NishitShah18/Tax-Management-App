//
//  RegistrationVC.swift
//  a4_ngshah3
//
//  Created by Nishit Shah on 2024-04-07.
//

import UIKit
import CoreLocation


class RegistrationVC: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var websiteTextField: UITextField!
    @IBOutlet var addressStreetTextField: UITextField!
    @IBOutlet var addressSuiteTextField: UITextField!
    @IBOutlet var addressCityTextField: UITextField!
    @IBOutlet var addressZipccodeTextField: UITextField!
    @IBOutlet var companyNameTextField: UITextField!
    @IBOutlet var companyCatchPhraseTextField: UITextField!
    @IBOutlet var companyBsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func RegisterBtn(_ sender: Any) {
        let addressString = "\(addressStreetTextField.text ?? ""), \(addressSuiteTextField.text ?? ""), \(addressCityTextField.text ?? ""), \(addressZipccodeTextField.text ?? "")"
                
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(addressString) { [self] placemarks, error in
                guard let placemark = placemarks?.first, let location = placemark.location else {
                    // Handle error
                    print("Error finding location: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                // Extract latitude and longitude
                let geoLat = Int64(location.coordinate.latitude * 1e6)
                let geoLng = Int64(location.coordinate.longitude * 1e6)
                
                print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
                        
                
                // Insert details into Core Data
                CoreDataHandler.shared.insertUser(
                    name: nameTextField.text ?? "",
                    username: usernameTextField.text ?? "",
                    email: emailTextField.text ?? "",
                    addressStreet: addressStreetTextField.text ?? "",
                    addressSuite: addressSuiteTextField.text ?? "",
                    addressCity: addressCityTextField.text ?? "",
                    addressZipcode: addressZipccodeTextField.text ?? "",
                    geoLat: geoLat,
                    geoLng: geoLng,
                    phone: Int64(phoneTextField.text ?? "") ?? 0,
                    website: websiteTextField.text ?? "",
                    companyName: companyNameTextField.text ?? "",
                    companyCatchPhrase: companyCatchPhraseTextField.text ?? "",
                    companyBs: companyBsTextField.text ?? "",
                    password: passwordTextField.text ?? "",
                    id: 1,
                    status: 1
                ) {
                    // Insertion successful, show alert
                    let alert = UIAlertController(title: "Success", message: "Registration successful!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
                        // Move to the MainVC
                        if let vc = self.storyboard?.instantiateViewController(identifier: "LoginScreen") as? MainVC {
                            // Hide the back button
                            vc.navigationItem.setHidesBackButton(true, animated: false)
                            
                            // Push the view controller onto the navigation stack
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
    }
    

}
