//
//  HMProductCell.swift
//  AmazonProductBrowser
//
//  Created by Varun Bansal on 4/19/16.
//  Copyright © 2016 Homee. All rights reserved.
//

import UIKit

@objc protocol HMProductCellDelegate {
    optional func movieRemovedFromLoveList(cell: UITableViewCell)
    optional func movieFavoriteButtonClicked(movieObject: HMMovieInfo)
}

/**
    HMProductCell
    
    Represents the movie cell that is displayed in all the views that shows listing of movies
    
    This customized cell handles configuring cell data using HMMovieInfo model object.
    This class also handles any interaction that happens over this cell like Love and Favorite buttons
 */

class HMProductCell: UITableViewCell {

    var mMovieObject: HMMovieInfo! {
        didSet {
            mTitle.text = mMovieObject.mOriginalTitle

            //cell.imageView.set
            if let imagePath = mMovieObject.fullPosterPath {
                mImageView.setImageWithURL(NSURL(string: imagePath)! , placeholderImage: UIImage(named: "placeholder"))
            }
            
            mMovieObject.mLove = HMSharedData.sharedInstance.isInLoveList(mMovieObject)
            
            mMovieObject.mLove ? mLoveButton.setImage(UIImage(named: "love_solid_red"), forState: .Normal) : mLoveButton.setImage(UIImage(named: "love_line_red"), forState: .Normal)
            
            HMSharedData.sharedInstance.isInFavoriteList(mMovieObject) ? mFavoriteButton.setImage(UIImage(named: "favorite_solid_red"), forState: .Normal) : mFavoriteButton.setImage(UIImage(named: "favorite_line_red"), forState: .Normal)
                
            
        }
    }
    
    var mCellDelegate: HMProductCellDelegate?
    
    
    @IBOutlet var mImageView: UIImageView!
    
    @IBOutlet var mTitle: UILabel!
    
    @IBOutlet var mLoveButton: UIButton!
    @IBOutlet var mFavoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func loveButtonClicked(sender: AnyObject) {
        
        mMovieObject.mLove = !mMovieObject.mLove
        
        if mMovieObject.mLove {
            HMSharedData.sharedInstance.addToLoveList(mMovieObject)
            mLoveButton.setImage(UIImage(named: "love_solid_red"), forState: .Normal)
        } else {
            let cell = sender.superview??.superview?.superview as! UITableViewCell
            HMSharedData.sharedInstance.removeFromLoveList(mMovieObject)
            mLoveButton.setImage(UIImage(named: "love_line_red"), forState: .Normal)
            mCellDelegate?.movieRemovedFromLoveList!(cell)
        }
        
    }

    @IBAction func favoriteButtonClicked(sender: AnyObject) {
        mCellDelegate?.movieFavoriteButtonClicked!(mMovieObject)
        
    }
    
}
