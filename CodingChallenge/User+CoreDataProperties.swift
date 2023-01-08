//
//  User+CoreDataProperties.swift
//  CodingChallenge
//
//  Created by Imran Kazi on 07/01/23.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var password: String?
    @NSManaged public var username: String?

}

extension User : Identifiable {

}
