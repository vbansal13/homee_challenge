//
//  HMFavoriteMoviesTableViewController.swift
//  AmazonProductBrowser
//
//  Created by Varun Bansal on 4/26/16.
//  Copyright © 2016 Homee. All rights reserved.
//

import UIKit

/**
 HMFavoriteMoviesTableViewController
 
 Displays movies for a selected genre which user has added to their favorite list
 
 */

class HMFavoriteMoviesTableViewController: UITableViewController {
    
    var mGenreType: String = "Action"
    
    private var mMovieList: [HMMovieInfo] = []
    private let mCellID = "MovieCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.title = mGenreType
        
        self.tableView.registerNib(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: self.mCellID)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(HMFavoriteMoviesTableViewController.refreshMovies(_:)), forControlEvents: .ValueChanged)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshMovies(nil)
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
        return mMovieList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.mCellID, forIndexPath: indexPath) as! HMProductCell
        
        // Configure the cell...
        cell.selectionStyle = .None
        //cell.mCellDelegate = self
        
        cell.mMovieObject = mMovieList[indexPath.row]
        
        return cell
    }
    
    // MARK: Private Methods
    func refreshMovies(refresh: UIRefreshControl?) {
        mMovieList.removeAll()
        
        mMovieList = HMSharedData.sharedInstance.getFavoriteMoviesInGenre(mGenreType)
        self.tableView.reloadData()
        if let refreshControl = refresh {
            refreshControl.endRefreshing()
        }
    }
    
}
