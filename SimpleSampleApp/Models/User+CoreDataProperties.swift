//
//  User+CoreDataProperties.swift
//  
//
//  Created by Jason Casillas on 6/28/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var id: NSNumber
    @NSManaged var username: String?
    @NSManaged var email: String?
    @NSManaged var phone: String?
    @NSManaged var website: String?
    @NSManaged var company: Company?
    @NSManaged var address: NSManagedObject?

}
