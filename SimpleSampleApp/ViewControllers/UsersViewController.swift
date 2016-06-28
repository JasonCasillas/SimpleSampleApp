//
//  ViewController.swift
//  SimpleSampleApp
//
//  Created by Jason Casillas on 6/28/16.
//  Copyright © 2016 TWNH. All rights reserved.
//

import UIKit
import CoreData

class UsersViewController: UIViewController {

    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!

    override func loadView() {
        // Create all of the components for the view and all contained view controllers
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func setDataControllerAndUpdateUI(dataController:DataController) {
        self.dataController = dataController
        managedObjectContext = dataController.managedObjectContext

        if countOfAllUsers() == 0 {
            // If not, update the UI to notify the app user and download them in the background
            dataController.downloadDataForAllUsers({ 
                self.saveManagedObjectContext({
                    dispatch_async(dispatch_get_main_queue()) { // Updating the UI, so ensure it is on the main queue
                        self.updateUIWithUserInfo()
                    }
                })
                }, failureClosure: {
                    print("Try again, or update UI with failure...")
            })
        } else {
            updateUIWithUserInfo()
        }
    }

    func updateUIWithUserInfo() {
        print("Now we have some users... \(countOfAllUsers())")
    }


    // MARK: - User Core Data Functions
    func countOfAllUsers() -> Int {
        let usersFetchRequest = NSFetchRequest(entityName: "User")
        
        var countOfUsers = 0
        var error: NSError? = nil
        countOfUsers = managedObjectContext.countForFetchRequest(usersFetchRequest, error: &error)
        
        if error != nil {
            print("Failed to count users: \(error)")
        }
        
        return countOfUsers
    }

    func saveManagedObjectContext(successClosure:()->()) {
        do {
            try managedObjectContext.save()
            successClosure()
        } catch {
            print("Failure to save users and associated objects in main MOC: \(error)")
        }
    }
}

