//
//  HMFavoriteSelectorTableViewController.swift
//  AmazonProductBrowser
//
//  Created by Varun Bansal on 4/25/16.
//  Copyright © 2016 Homee. All rights reserved.
//

import UIKit

/**
 HMFavoriteSelectorTableViewController
 
 Display list of all the genres user has added to their favorite genre list
 User can select one genre from this list and associate it with a selected movie
 
 This view will be displayed when user clicks on favorite ("star") button from movie list
 
 */
class HMFavoriteSelectorTableViewController: UITableViewController {

    weak var mMovieObject: HMMovieInfo?
    
    private var lastSelectedIndexPath: NSIndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.title = "Select Category"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return HMSharedData.sharedInstance.numberOfFavoriteGenres()
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteCellID", forIndexPath: indexPath)
        
        // Configure the cell...
        let favoriteListName = HMSharedData.sharedInstance.favoriteGenreAt(indexPath.row)
        cell.accessoryType = .None
        cell.selectionStyle = .None
        
        if let movieObject = mMovieObject {
            
            if movieObject.isMarkedWithGenre(favoriteListName) {
                self.lastSelectedIndexPath = indexPath
                cell.accessoryType = .Checkmark
            }
        }
        cell.textLabel?.text = favoriteListName
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentCell = self.tableView.cellForRowAtIndexPath(indexPath)
        if currentCell?.accessoryType == .Checkmark {
            currentCell?.accessoryType = .None
            if let movieObject = mMovieObject {
                movieObject.mFavoriteCateogry = nil
            }
        } else {
            currentCell?.accessoryType = .Checkmark
            if let movieObject = mMovieObject {
                movieObject.mFavoriteCateogry = currentCell?.textLabel?.text
            }
            
            if let lastIndexPath = self.lastSelectedIndexPath {
                let lastCell = self.tableView.cellForRowAtIndexPath(lastIndexPath)
                lastCell?.accessoryType = .None
            }
        }
        self.lastSelectedIndexPath = indexPath
    }
    
}
