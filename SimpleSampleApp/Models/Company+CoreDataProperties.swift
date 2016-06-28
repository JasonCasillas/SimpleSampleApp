//
//  Company+CoreDataProperties.swift
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

extension Company {

    @NSManaged var name: String?
    @NSManaged var catchPhrase: String?
    @NSManaged var bs: String?
    @NSManaged var user: NSManagedObject?

}
