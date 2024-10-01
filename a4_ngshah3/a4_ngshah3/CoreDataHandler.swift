//
//  CoreDataHandler.swift
//  a4_ngshah3
//
//  Created by Nishit Shah on 2024-04-07.
//

//
//  CoreDataHandler.swift
//  a4_ngshah3
//
//  Created by Nishit Shah on 2024-04-07.
//

import Foundation
import UIKit
import CoreData

class CoreDataHandler {
  
    static let shared = CoreDataHandler()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext?
    
    private init() {
        context = appDelegate.persistentContainer.viewContext
    }
    
    func saveContext() {
        appDelegate.saveContext()
    }
    
    func insertUser(name: String, username: String, email: String, addressStreet: String, addressSuite: String, addressCity: String, addressZipcode: String, geoLat: Int64, geoLng: Int64, phone: Int64, website: String, companyName: String, companyCatchPhrase: String, companyBs: String, password: String, id: Int64, status: Int64, completion: @escaping () -> Void) {
        let newUser = User(context: context!)
        newUser.name = name
        newUser.username = username
        newUser.email = email
        newUser.address_street = addressStreet
        newUser.address_suite = addressSuite
        newUser.address_city = addressCity
        newUser.address_zipcode = addressZipcode
        newUser.geo_lat = geoLat
        newUser.geo_lng = geoLng
        newUser.phone = phone
        newUser.website = website
        newUser.company_name = companyName
        newUser.company_catchPhrase = companyCatchPhrase
        newUser.company_bs = companyBs
        newUser.password = password
        newUser.id = id
        newUser.status = status
        
        saveContext()
        completion()
    }
    
    func update(user: User, name: String, username: String, email: String, phone: Int64, website: String, password: String, completion: @escaping () -> Void) {
        user.name = name
        user.username = username
        user.email = email
        user.phone = phone
        user.website = website
        user.password = password
        
        saveContext()
        completion()
    }
    
    func updateProcess(user: User, password: String, status: Int64, completion: @escaping () -> Void) {
        user.status = status
        
        saveContext()
        completion()
    }
    
    func fetchData() -> [User] {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try context?.fetch(fetchRequest)
            return users ?? []
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteData(for user: User, completion: @escaping () -> Void) {
        context?.delete(user)
        saveContext()
        completion()
    }
    
    func deleteAllData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context?.execute(batchDeleteRequest)
            saveContext()
        } catch {
            print("Error deleting all data: \(error.localizedDescription)")
        }
    }
}
