//
//  User+CoreDataProperties.swift
//  a4_ngshah3
//
//  Created by Nishit Shah on 2024-04-07.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: Int64
    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var address_street: String?
    @NSManaged public var address_suite: String?
    @NSManaged public var address_city: String?
    @NSManaged public var address_zipcode: String?
    @NSManaged public var geo_lat: Int64
    @NSManaged public var geo_lng: Int64
    @NSManaged public var website: String?
    @NSManaged public var company_name: String?
    @NSManaged public var company_catchPhrase: String?
    @NSManaged public var company_bs: String?
    @NSManaged public var id: Int64
    @NSManaged public var status: Int64

}

extension User : Identifiable {

}
