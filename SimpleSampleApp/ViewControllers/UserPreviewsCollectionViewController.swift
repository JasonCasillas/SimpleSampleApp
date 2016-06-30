//
//  userPreviewsCollectionViewController.swift
//  SimpleSampleApp
//
//  Created by Jason Casillas on 6/28/16.
//  Copyright © 2016 TWNH. All rights reserved.
//

import UIKit
import CoreData

protocol UserPreviewsCollectionViewControllerDelegate {
    func userPreviewsCollectionViewControllerSelectedUser(user:User)
}

private let reuseIdentifier = "userPreviewCell"

class UserPreviewsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {

    var dataController: DataController!
    var fetchedResultsController: NSFetchedResultsController?
    var delegate: UserPreviewsCollectionViewControllerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        self.collectionView!.registerClass(UserPreviewCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.backgroundColor = UIColor.whiteColor()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setDataControllerAndUpdateUI(dataController:DataController) {
        self.dataController = dataController
        initializeFetchedResultsController()
        collectionView?.reloadData()
    }

    func initializeFetchedResultsController() {
        let request = NSFetchRequest(entityName: "User")
        let idSort = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [idSort]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: dataController.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController!.delegate = self
        
        do {
            try fetchedResultsController!.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }



    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if fetchedResultsController != nil {
            return fetchedResultsController!.sections!.count
        } else {
            return 0
        }
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if fetchedResultsController != nil {
            let sections = fetchedResultsController!.sections as [NSFetchedResultsSectionInfo]!
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        } else {
            return 0
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UserPreviewCollectionViewCell {
        let userPreviewCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! UserPreviewCollectionViewCell

        // Configure the cell
        let user = fetchedResultsController!.objectAtIndexPath(indexPath) as! User
        userPreviewCollectionViewCell.fillAndRearrangeLabelsForUser(user)

        return userPreviewCollectionViewCell
    }


    // MARK: UICollectionViewDelegate
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectedUser = fetchedResultsController!.objectAtIndexPath(indexPath) as! User
        delegate.userPreviewsCollectionViewControllerSelectedUser(selectedUser)
    }


    // UICollectionViewDelegateFlowLayout
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(300.0, 172.0)
    }
}
