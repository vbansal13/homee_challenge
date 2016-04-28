//
//  HMCatalogViewController.swift
//  AmazonProductBrowser
//
//  Created by Varun Bansal on 4/19/16.
//  Copyright © 2016 Homee. All rights reserved.
//

import UIKit

/**
    HMCatalogViewController
 
    Manages view and model for collection of various movie catalogs
    This will be user's home screen
 */
class HMCatalogViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var mSearchButton: UIBarButtonItem!
    
    private let kShowCategoryProductsSequeName = "showCategoryProductsSeque"
    
    private let mColorWheel = ColorWheel()
    
    private var mSearchController: UISearchController?
    private var mSearchResultsViewController: HMSearchResultsTableViewController?
    private var mRandomColors: [UIColor] = []
    
    private let mCatalog:[(name: String, searchKey: String)] =
        [(name: "Most Popular", searchKey: kJLTMDbMoviePopular),
         (name: "Now Playing", searchKey: kJLTMDbMovieNowPlaying),
         (name: "Action", searchKey: "genre/28/movies"),
         (name: "Adventure", searchKey: "genre/12/movies"),
         (name: "Animation", searchKey: "genre/16/movies"),
         (name: "Comedy", searchKey: "genre/35/movies"),
         (name: "Drama", searchKey: "genre/18/movies"),
         (name: "Family", searchKey: "genre/10751/movies"),
         (name: "Fantasy", searchKey: "genre/14/movies"),
         (name: "Science Fiction", searchKey: "genre/878/movies"),
         (name: "Thriller", searchKey: "genre/53/movies")]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mCatalog.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier("catalogCellID", forIndexPath: indexPath) as! HMCatalogCollectionViewCell
        
        cell.title.text = mCatalog[indexPath.row].name
        
        if mRandomColors.count <= indexPath.row {
            mRandomColors.append(mColorWheel.getRandomColor())
        }
        
        cell.backgroundColor = mRandomColors[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let numberOfCellInRow: CGFloat = 2;
        let width = (UIScreen.mainScreen().bounds.size.width - 15) / numberOfCellInRow
        return CGSizeMake(width, width);
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(self.kShowCategoryProductsSequeName, sender: nil)
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == self.kShowCategoryProductsSequeName {
            let indexPaths = self.collectionView.indexPathsForSelectedItems()
            let indexPath = indexPaths![0] as NSIndexPath
            
            let productListVC = segue.destinationViewController as! HMMoviesTableViewController
            
            productListVC.mTitle = mCatalog[indexPath.row].name
            //set query data on this
            productListVC.mSearchCategory = mCatalog[indexPath.row].searchKey
        }
    }
    
    // MARK: SearchBar Delegate
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.navigationItem.titleView = nil
        self.navigationItem.rightBarButtonItem = self.mSearchButton
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.mSearchResultsViewController?.searchMovie(searchBar.text)
    }
    
    
    @IBAction func searchClicked(sender: AnyObject) {
        
        if self.mSearchController == nil {
            self.mSearchResultsViewController = HMSearchResultsTableViewController(nibName: "HMSearchResultsTableViewController", bundle: nil)
            
            self.mSearchController = UISearchController(searchResultsController: self.mSearchResultsViewController)
            self.mSearchController?.searchResultsUpdater = self.mSearchResultsViewController
            
            self.mSearchController?.hidesNavigationBarDuringPresentation = false
            self.mSearchController?.dimsBackgroundDuringPresentation = true
            self.mSearchController?.searchBar.showsCancelButton = true
            self.mSearchController?.searchBar.delegate = self
            definesPresentationContext = true
        }
        self.mSearchController?.searchBar.becomeFirstResponder()
        self.navigationItem.titleView = self.mSearchController?.searchBar
        self.navigationItem.rightBarButtonItem = nil
    }
    
    


}
