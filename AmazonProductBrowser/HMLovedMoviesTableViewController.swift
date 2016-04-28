//
//  HMLovedMoviesTableViewController.swift
//  AmazonProductBrowser
//
//  Created by Varun Bansal on 4/24/16.
//  Copyright © 2016 Homee. All rights reserved.
//

import UIKit

/**
    HMLovedMoviesTableViewController
 
    Manages view and model for movies that user has added to their love list
 
 */

class HMLovedMoviesTableViewController: UITableViewController, HMProductCellDelegate {

    private var mMovieList: [Int] = []
    private let mCellID = "MovieCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.registerNib(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: self.mCellID)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(HMLovedMoviesTableViewController.refreshMovies(_:)), forControlEvents: .ValueChanged)
        
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
        cell.mCellDelegate = self
        if let item = HMSharedData.sharedInstance.getMovie(self.mMovieList[indexPath.row]) {
            cell.mMovieObject = item
        }

        
        return cell
    }

    
    // MARK: Private Methods
    func refreshMovies(refresh: UIRefreshControl?) {
        mMovieList.removeAll()
        
        mMovieList = HMSharedData.sharedInstance.getLovedMovieIds()
        self.tableView.reloadData()
        if let refreshControl = refresh {
            refreshControl.endRefreshing()
        }
    }
    
    // MARK: HMProductCell Delegate
    
    @objc func movieRemovedFromLoveList(cell: UITableViewCell) {
        let iPathRow = self.tableView.indexPathForCell(cell)!.row
        mMovieList.removeAtIndex(iPathRow)
        
        self.tableView.deleteRowsAtIndexPaths([self.tableView.indexPathForCell(cell)!], withRowAnimation: .Automatic)
        
    }
    
    @objc func movieFavoriteButtonClicked(movieObject: HMMovieInfo) {
        
        let favoriteVC = self.storyboard?.instantiateViewControllerWithIdentifier("FavoriteSelectorViewController") as! HMFavoriteSelectorTableViewController
        favoriteVC.mMovieObject = movieObject
        self.navigationController?.pushViewController(favoriteVC, animated: true);
    }
}
