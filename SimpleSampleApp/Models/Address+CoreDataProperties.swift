//
//  Address+CoreDataProperties.swift
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

extension Address {

    @NSManaged var street: String?
    @NSManaged var suite: String?
    @NSManaged var city: String?
    @NSManaged var zipcode: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var user: User?

}
