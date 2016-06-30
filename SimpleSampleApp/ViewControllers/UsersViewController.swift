//
//  ViewController.swift
//  SimpleSampleApp
//
//  Created by Jason Casillas on 6/28/16.
//  Copyright © 2016 TWNH. All rights reserved.
//

import UIKit
import CoreData

class UsersViewController: UIViewController, UserPreviewsCollectionViewControllerDelegate {

    var dataController: DataController!
    var managedObjectContext: NSManagedObjectContext!
    var userPreviewsCollectionViewController: UserPreviewsCollectionViewController!
    var userPreviewsCollectionView:UICollectionView!
    var userInfoScrollView: UserInfoScrollView!
    var downloadFailureButton: UIButton!
    let userPreviewsCollectionViewHeight:CGFloat = 180.0
    let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.size.height

    override func loadView() {
        // Create all of the components for the view and all contained view controllers
        super.loadView()

        setupUserPreviewsCollectionView()
        setupUserInfoScrollView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupUserPreviewsCollectionView() {
        let userPreviewsCollectionViewFlowLayout = UICollectionViewFlowLayout()
        userPreviewsCollectionViewFlowLayout.scrollDirection = .Horizontal
        userPreviewsCollectionViewController = UserPreviewsCollectionViewController(collectionViewLayout: userPreviewsCollectionViewFlowLayout)
        userPreviewsCollectionViewController.delegate = self

        userPreviewsCollectionView = userPreviewsCollectionViewController.collectionView!

        userPreviewsCollectionView.frame = CGRectMake(0.0, statusBarHeight, view.bounds.size.width, userPreviewsCollectionViewHeight)
        userPreviewsCollectionView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(userPreviewsCollectionView)

        userPreviewsCollectionView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        userPreviewsCollectionView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        userPreviewsCollectionView.topAnchor.constraintEqualToAnchor(view.topAnchor, constant: statusBarHeight).active = true
        userPreviewsCollectionView.heightAnchor.constraintEqualToConstant(userPreviewsCollectionViewHeight).active = true
    }

    func setupUserInfoScrollView() {
        userInfoScrollView = UserInfoScrollView(frame: CGRectMake(0.0,
                                                                  userPreviewsCollectionViewHeight + statusBarHeight,
                                                                  view.bounds.size.width,
                                                                  view.bounds.size.height - userPreviewsCollectionViewHeight))
        userInfoScrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userInfoScrollView)
        userInfoScrollView.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        userInfoScrollView.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
        userInfoScrollView.topAnchor.constraintEqualToAnchor(userPreviewsCollectionView.bottomAnchor).active = true
        userInfoScrollView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
    }


    func setDataControllerAndUpdateUI(dataController:DataController) {
        self.dataController = dataController
        managedObjectContext = dataController.managedObjectContext

        if countOfAllUsers() == 0 {
            // If not, update the UI to notify the app user and download them in the background
            attemptDownloadOfUserData()
        } else {
            updateUIWithUserInfo()
        }
    }

    func attemptDownloadOfUserData() {
        dataController.downloadDataForAllUsers({
            self.saveManagedObjectContext({
                dispatch_async(dispatch_get_main_queue()) { // Updating the UI, so ensure it is on the main queue
                    self.updateUIWithUserInfo()
                }
            })
            }, failureClosure: {
                dispatch_async(dispatch_get_main_queue()) { // Updating the UI, so ensure it is on the main queue
                    self.updateUIForFailedDownload()
                }
        })
    }

    func updateUIWithUserInfo() {
        userPreviewsCollectionViewController.setDataControllerAndUpdateUI(dataController)
        userInfoScrollView.fillAndRearrangeLabelsForUser(firstUserById())
    }

    func updateUIForFailedDownload() {
        downloadFailureButton = UIButton(type: .System)
        downloadFailureButton.setTitle("User data pull failed. Tap to try again.", forState: .Normal)
        downloadFailureButton.titleLabel?.font = UIFont.systemFontOfSize(18.0, weight: UIFontWeightMedium)
        downloadFailureButton.frame = CGRectMake(20.0, view.bounds.size.height/2.0 - 100.0, view.bounds.size.width - 40.0, 200.0)
        downloadFailureButton.addTarget(self, action: #selector(tappedRetryDownloadButton), forControlEvents: .TouchUpInside)
        view.addSubview(downloadFailureButton)
    }


    // MARK: - Gesture Handlers
    func tappedRetryDownloadButton(sender:UIButton) {
        downloadFailureButton.removeFromSuperview()
        attemptDownloadOfUserData()
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

    func firstUserById() -> User {
        let userFetchRequest = NSFetchRequest(entityName: "User")
        let idSort = NSSortDescriptor(key: "id", ascending: true)
        userFetchRequest.sortDescriptors = [idSort]
        userFetchRequest.fetchLimit = 1

        var firstUser:User

        do {
            let singleUserArray = try managedObjectContext.executeFetchRequest(userFetchRequest) as! [User]
            firstUser = singleUserArray.first!
        } catch {
            fatalError("Failed to fetch first user: \(error)")
        }

        return firstUser
    }

    func saveManagedObjectContext(successClosure:()->()) {
        do {
            try managedObjectContext.save()
            successClosure()
        } catch {
            print("Failure to save users and associated objects in main MOC: \(error)")
        }
    }


    // MARK: - UserPreviewsCollectionViewController Delegate
    func userPreviewsCollectionViewControllerSelectedUser(user:User) {
        userInfoScrollView.fillAndRearrangeLabelsForUser(user)
    }
}

