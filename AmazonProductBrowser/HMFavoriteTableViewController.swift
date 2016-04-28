//
//  HMFavoriteTableViewController.swift
//  AmazonProductBrowser
//
//  Created by Varun Bansal on 4/25/16.
//  Copyright © 2016 Homee. All rights reserved.
//

import UIKit


/**
 HMFavoriteTableViewController
 
 Manages view and model for user's favorite genre list
 
 User can add new favorite genres or remove the existing ones
 Removing an existing genre will also remove all the movies from favorite movie list that has
 the removed genre name

 */

class HMFavoriteTableViewController: UITableViewController, UITextFieldDelegate {

    private let kShowGenreMoviesSequeName = "showGenreMoviesSeque"
    private var mEditingLastRow = false
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteCellID", forIndexPath: indexPath) as! HMGenreCell

        // Configure the cell...
        let favoriteListName = HMSharedData.sharedInstance.favoriteGenreAt(indexPath.row)
        cell.textLabel?.text = favoriteListName
        cell.selectionStyle = .None
        cell.inputField.hidden = true
        if self.mEditingLastRow && (indexPath.row == HMSharedData.sharedInstance.numberOfFavoriteGenres() - 1) {
            cell.inputField.hidden = false
            cell.inputField.becomeFirstResponder()
            cell.inputField.delegate = self
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier(self.kShowGenreMoviesSequeName, sender: nil)
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            
            HMSharedData.sharedInstance.removeFavoriteGenreAt(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    //MARK: - UITextFieldDelegate Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        HMSharedData.sharedInstance.renameFavoriteGenreAt(HMSharedData.sharedInstance.numberOfFavoriteGenres() - 1, newName: textField.text!)
        textField.resignFirstResponder()
        textField.hidden = true
        self.mEditingLastRow = false
        let cell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forRow: HMSharedData.sharedInstance.numberOfFavoriteGenres()-1, inSection: 0))
        cell?.textLabel?.text = textField.text!
        
        return true
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let favoriteListName = HMSharedData.sharedInstance.favoriteGenreAt(indexPath.row)
            
            let movieVC = segue.destinationViewController as! HMFavoriteMoviesTableViewController
            
            movieVC.mGenreType = favoriteListName
            
        }
        
        
    }
    
    @IBAction func addNewItem(sender: AnyObject) {
        self.mEditingLastRow = true
        let indexPath = NSIndexPath(forRow: HMSharedData.sharedInstance.numberOfFavoriteGenres(), inSection: 0)
        HMSharedData.sharedInstance.addToFavoriteGenres("")
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

}
