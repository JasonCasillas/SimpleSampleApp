//
//  DataController.swift
//  SimpleSampleApp
//
//  Created by Jason Casillas on 6/28/16.
//  Copyright © 2016 TWNH. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import AlamofireObjectMapper

class DataController: NSObject {

    var managedObjectContext: NSManagedObjectContext

    init(startupCompletionClosure:()->()) {

        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = NSBundle.mainBundle().URLForResource("SimpleSampleApp", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }

        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let managedObjectModel = NSManagedObjectModel(contentsOfURL: modelURL) else {
            fatalError("Error initializing managedObjectModel from: \(modelURL)")
        }

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
            let docURL = urls[urls.endIndex-1]
            let persistentStoreOptions = [NSMigratePersistentStoresAutomaticallyOption:true, NSInferMappingModelAutomaticallyOption:true]

            let storeURL = docURL.URLByAppendingPathComponent("SimpleSampleApp.sqlite")
            do {
                try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: persistentStoreOptions)
                startupCompletionClosure()
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
    }

    func downloadDataForAllUsers(successClosure:()->(), failureClosure:()->()) {
        let URL = "http://" + "jsonplaceholder" + ".typicode." + "com" + "/users" // Pulled this apart to make it more difficult for people to find based on the URL
        Alamofire.request(.GET, URL).responseArray { (response: Response<[UserMappable], NSError>) in

            if let userMappablesArray = response.result.value {
                self.saveUsersFromUserMappables(userMappablesArray, successClosure: successClosure, failureClosure: failureClosure)
            } else {
                print("No users retrieved... handle this")
                failureClosure()
            }
        }
    }

    func saveUsersFromUserMappables(userMappablesArray:[UserMappable], successClosure:()->(), failureClosure:()->()) {
        let privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        privateManagedObjectContext.parentContext = managedObjectContext

        privateManagedObjectContext.performBlock {
            for userMappable in userMappablesArray {
                let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: privateManagedObjectContext) as! User
                newUser.id = NSNumber(integer: userMappable.id)
                newUser.name = userMappable.name
                newUser.username = userMappable.username
                newUser.email = userMappable.email
                newUser.phone = userMappable.phone
                newUser.website = userMappable.website

                let newAddress = NSEntityDescription.insertNewObjectForEntityForName("Address", inManagedObjectContext: privateManagedObjectContext) as! Address
                newAddress.street = userMappable.addressStreet
                newAddress.suite = userMappable.addressSuite
                newAddress.city = userMappable.addressCity
                newAddress.zipcode = userMappable.addressZipcode
                newAddress.latitude = userMappable.addressLatitude
                newAddress.longitude = userMappable.addressLongitude
                newUser.address = newAddress

                let newCompany = NSEntityDescription.insertNewObjectForEntityForName("Company", inManagedObjectContext: privateManagedObjectContext) as! Company
                newCompany.name = userMappable.companyName
                newCompany.catchPhrase = userMappable.companyCatchPhrase
                newCompany.bs = userMappable.companyBS
                newUser.company = newCompany
            }

            do {
                try privateManagedObjectContext.save()
                successClosure()
            } catch {
                print("Failure to save users and associated objects to private MOC: \(error)")
                failureClosure()
            }
        }
    }
}
