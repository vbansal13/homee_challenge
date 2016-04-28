//
//  HMSearchResultsTableViewController.swift
//  AmazonProductBrowser
//
//  Created by Varun Bansal on 4/24/16.
//  Copyright © 2016 Homee. All rights reserved.
//

import UIKit


/**
    HMSearchResultsTableViewController
 
    This will display search results for movies whose title matches given search title
 */
class HMSearchResultsTableViewController: UITableViewController, UISearchResultsUpdating, HMProductCellDelegate {
    
    private let mCellID = "MovieCellID"
    private var mTableData: [HMMovieInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableView.registerNib(UINib(nibName: "MovieCell", bundle: nil), forCellReuseIdentifier: self.mCellID)
        //self.tableView.frame = CGRectMake(0, 64, self.tableView.frame.size.width, self.tableView.frame.size.height-64);
        
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
        cell.selectionStyle = .None
        let item = self.mTableData[indexPath.row]
        cell.mMovieObject = item
        cell.mCellDelegate = self
        
        return cell

    }
    
    
    //MARK : - Search Results Updating Delgate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        //No need to do anything here, will perform search when user press search button
    }
    
    func searchMovie(searchText: String?) {
        
        if let sText = searchText {
            HMMovieDBClientHelper.sharedInstance.getMovieListAsynchronously(searchAPIKey: kJLTMDbSearchMovie, withParameters: ["query" : sText],  callBack: { (objects: [HMMovieInfo]?, error: NSError?) in
                self.mTableData.removeAll(keepCapacity: false)
                
                if let er = error {
                    print(er.localizedDescription)
                } else {
                    self.mTableData.removeAll(keepCapacity: false)
                    self.mTableData.appendContentsOf(objects!)
                }
                
                self.tableView.reloadData()
                self.tableView.setContentOffset(CGPointMake(0.0
                    , -self.tableView.contentInset.top), animated:true)
            })
        }
    }
    
    // MARK: HMProductCell Delegate
    
    @objc func movieFavoriteButtonClicked(movieObject: HMMovieInfo) {
        
        let favoriteVC = self.storyboard?.instantiateViewControllerWithIdentifier("FavoriteSelectorViewController") as! HMFavoriteSelectorTableViewController
        favoriteVC.mMovieObject = movieObject
        self.navigationController?.pushViewController(favoriteVC, animated: true);
    }
    
}
