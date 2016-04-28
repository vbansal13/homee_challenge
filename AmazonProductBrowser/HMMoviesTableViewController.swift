//
//  HMMoviesTableViewController.swift
//  AmazonProductBrowser
//
//  Created by Varun Bansal on 4/23/16.
//  Copyright © 2016 Homee. All rights reserved.
//

import UIKit

/**
 HMMoviesTableViewController
 
 Manages view and model for a selected collection of movies like "Action", "Most Popular"
 This will be displayed when user selects a particular collection from home screen
 */
class HMMoviesTableViewController: UITableViewController, HMProductCellDelegate {

    var mSearchCategory = "All"
    var mTitle = "Movies"
    private let mCellID = "MovieCellID"
    
    private var mTableData: [HMMovieInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.registerNib(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: self.mCellID)
        
        self.navigationItem.title = self.mTitle
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(HMMoviesTableViewController.refreshMovies(_:)), forControlEvents: .ValueChanged)
        
        refreshMovies(nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let visibleIndexPaths = self.tableView.indexPathsForVisibleRows {
            self.tableView.reloadRowsAtIndexPaths(visibleIndexPaths, withRowAnimation: .Fade)
        }
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
        return mTableData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(self.mCellID, forIndexPath: indexPath) as! HMProductCell
        
        // Configure the cell...
        let item = self.mTableData[indexPath.row]
        cell.selectionStyle = .None
        cell.mMovieObject = item
        cell.mCellDelegate = self
        
        self.tableView.indexPathsForVisibleRows
        return cell
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Private Methods
    func refreshMovies(refresh: UIRefreshControl?) {
        
        HMMovieDBClientHelper.sharedInstance.getMovieListAsynchronously(searchAPIKey: mSearchCategory, withParameters: nil,  callBack: { (objects: [HMMovieInfo]?, error: NSError?) in
            
            if let er = error {
                print(er.localizedDescription)
            } else {
                self.mTableData.removeAll(keepCapacity: false)
                self.mTableData.appendContentsOf(objects!)
            }
            
            self.tableView.reloadData()
            
            if let refreshControl = refresh {
                refreshControl.endRefreshing()
            }
        })
        
    }
    
    // MARK: HMProductCell Delegate
    
    @objc func movieFavoriteButtonClicked(movieObject: HMMovieInfo) {
        
        let favoriteVC = self.storyboard?.instantiateViewControllerWithIdentifier("FavoriteSelectorViewController") as! HMFavoriteSelectorTableViewController
        favoriteVC.mMovieObject = movieObject
        self.navigationController?.pushViewController(favoriteVC, animated: true);
    }

}
