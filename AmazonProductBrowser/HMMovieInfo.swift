//
//  HMMovieInfo.swift
//  AmazonProductBrowser
//
//  Created by Varun Bansal on 4/23/16.
//  Copyright © 2016 Homee. All rights reserved.
//

import UIKit

/**
 HMMovieInfo
 
 Model class for holding and managing a single instance of movie object downloaded from 
 MovieDB database
 
 */

class HMMovieInfo: NSObject, NSCoding {

    struct PropertyKey {
        static let idKey = "id"
        static let titleKey = "title"
        static let posterPathKey = "posterPath"
        static let backdropPathKey = "backdropPath"
        static let loveKey = "love"
        static let favoriteCategoryKey = "favorite"
    }
    var mOriginalTitle: String
    var mPosterPath: String?
    
    var mBackdropPath: String?
    var mMovieId: Int
    
    var mLove = false
    var mFavoriteCateogry: String? {
        didSet{
            
            if mFavoriteCateogry == nil {
                HMSharedData.sharedInstance.removeFromLoveList(self)
            } else {
                HMSharedData.sharedInstance.addToFavoriteList(self)
            }
        }
    }
    
    var fullPosterPath: String? {
        get {
            if let posterPath = mBackdropPath {
                
                let baseURLString = HMMovieDBClientHelper.sharedInstance.mBaseURLString!.stringByReplacingOccurrencesOfString("w92", withString: "w780")
                
                let imageString = baseURLString.stringByAppendingString(posterPath)
                return imageString
            } else if let posterPath = mPosterPath {
                let baseURLString = HMMovieDBClientHelper.sharedInstance.mBaseURLString!.stringByReplacingOccurrencesOfString("w92", withString: "w500")
                
                let imageString = baseURLString.stringByAppendingString(posterPath)
                return imageString
            }
            return nil;
        }
    }
    
    init(id: Int, title: String, posterPath: String?, backdropPath: String?, love: Bool, favoriteCategory: String?) {
        mMovieId = id
        mOriginalTitle = title
        
        mPosterPath = posterPath
        mBackdropPath = backdropPath
        mLove = love
        mFavoriteCateogry = favoriteCategory
    }
    
    
    init(id: Int, title: String) {
        mMovieId = id
        mOriginalTitle = title
    }
    
    func isMarkedWithGenre(genre: String) -> Bool {
        
        if let favorite = mFavoriteCateogry {
            if favorite == genre {
                return true
            }
        }
        return false
    }
    
    // MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeIntegerForKey(PropertyKey.idKey)
        let title = aDecoder.decodeObjectForKey(PropertyKey.titleKey) as! String
        let posterPath = aDecoder.decodeObjectForKey(PropertyKey.posterPathKey) as? String
        let backdropPath = aDecoder.decodeObjectForKey(PropertyKey.backdropPathKey) as? String
        let love = aDecoder.decodeBoolForKey(PropertyKey.loveKey) as Bool
        let favorite = aDecoder.decodeObjectForKey(PropertyKey.favoriteCategoryKey) as? String
        
        self.init(id: id, title: title, posterPath: posterPath, backdropPath: backdropPath, love: love, favoriteCategory: favorite)
        
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(mMovieId, forKey: PropertyKey.idKey)
        aCoder.encodeObject(mOriginalTitle, forKey: PropertyKey.titleKey)
        aCoder.encodeObject(mPosterPath, forKey: PropertyKey.posterPathKey)
        aCoder.encodeObject(mBackdropPath, forKey: PropertyKey.backdropPathKey)
        aCoder.encodeBool(mLove, forKey: PropertyKey.loveKey)
        aCoder.encodeObject(mFavoriteCateogry, forKey: PropertyKey.favoriteCategoryKey)
        
    }
    
    
    

}
