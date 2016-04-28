//
//  HMMovieDBClientHelper.swift
//  AmazonProductBrowser
//
//  Created by Varun Bansal on 4/28/16.
//  Copyright © 2016 Homee. All rights reserved.
//

import UIKit


/**
 HMMovieDBClientHelper is wrapper class for JLTMDbClient API
 It encapsulates all the network requests that will be needed to downlaod and work
 with any data that is retreived from MovieDB database
 */
class HMMovieDBClientHelper: NSObject {
    static let sharedInstance = HMMovieDBClientHelper()
    
    var mBaseURLString: String?
    
    //This prevents others from using default initializer for this class
    //making it truly singleton
    private override init() { }
    
    /**
        Asynchronous functions for downloading contents from MovieDB database
     
        - Param searchAPIKey: Provides API endpoint that will be used to make network request
        - Param withParameters: Provides optional parameters that will be passed as key-value pairs
        - Param callBack Provides: callback method that will be called when network request finishes
    */
    func getMovieListAsynchronously(searchAPIKey searchKey: String, withParameters parameters: [NSObject : AnyObject]?, callBack: (objects: [HMMovieInfo]?, error: NSError?) -> Void) {
        JLTMDbClient.sharedAPIInstance().GET(searchKey, withParameters: parameters) { (responseObject: AnyObject?, error: NSError?) in
            
            if let _ = error {
                //print(er.localizedDescription)
                callBack(objects: nil, error: error)
                
            } else {
                print(responseObject)
                //self.mTableData.removeAllObjects()
                var movieData: [HMMovieInfo] = []
                
                let movieList = responseObject!["results"] as! [[String: AnyObject!]]
                for movie in movieList {
                    
                    let posterPath = movie["poster_path"] as? String
                    let backdropPath = movie["backdrop_path"] as? String
                    let movieId = movie["id"] as! NSNumber
                    
                    let movieObject = HMMovieInfo(id: movieId.integerValue, title: movie["original_title"] as! String)
                    
                    movieObject.mBackdropPath = backdropPath
                    movieObject.mPosterPath = posterPath
                    movieObject.mLove = HMSharedData.sharedInstance.isInLoveList(movieObject)
                    
                    if let mTemp = HMSharedData.sharedInstance.getFavoriteMovie(movieObject.mMovieId) {
                        movieObject.mFavoriteCateogry = mTemp.mFavoriteCateogry
                    }
                    
                    
                    movieData.append(movieObject)
                    
                }
                
                callBack(objects: movieData, error: nil)
            }
            
        }
    }
    
    /**
        Method for loading initial configuration from MovieDB API
        It will retrieve same basic information which will be used for future network queries
     */
    func loadConfiguration() {
        
        JLTMDbClient.sharedAPIInstance().APIKey = "3b1c3ccaf157587bd882bac90b8eba46"
        JLTMDbClient.sharedAPIInstance().GET(kJLTMDbConfiguration, withParameters: nil) { (response: AnyObject!, error: NSError?) in
            if let er = error {
                print(er.localizedDescription)
            } else {
                //print("\(response)")
                let responseImageDict = response["images"] as! [String: AnyObject!]
                
                self.mBaseURLString = responseImageDict["base_url"]!.stringByAppendingString("w92")
                
            }
            
        }
    }
    
}
