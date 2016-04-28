//
//  HMSharedData.swift
//  AmazonProductBrowser
//
//  Created by Varun Bansal on 4/23/16.
//  Copyright © 2016 Homee. All rights reserved.
//

import UIKit

/**
 HMSharedData is a singleton class for managing shared data for the application
 */
class HMSharedData: NSObject {
    static let sharedInstance = HMSharedData()
    
    static let documentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let movieLoveListArchiveURL = documentsDirectory.URLByAppendingPathComponent("movieLoveList")
    static let movieFavoriteListArchiveURL = documentsDirectory.URLByAppendingPathComponent("movieFavoriteList")
    static let movieFavoriteGenreArchiveURL = documentsDirectory.URLByAppendingPathComponent("movieFavoriteGenres")
    
    
    private var mLoveList: [Int: HMMovieInfo] = [:]
    
    private var mFavoriteList: [Int: HMMovieInfo] = [:]
    
    private var mFavoriteGenreList: [String] = ["Action", "Comedy", "Drama", "Horror", "Sci-Fi", "Suspense"]
    
    
    //This prevents others from using default initializer for this class
    //making it truly singleton
    private override init() { }
    
    
    
    //MARK: Methods for managing configuration
    
    /**
        Loads all the saved configuration from user's phone app document directory
    */
    func loadConfiguration() {
        loadLoveList()
        loadFavoriteList()
        loadFavoriteGenres()
        
    }
    
    /**
        Saves all the current configuration into app's document directory
    */
    func saveConfiguration() {
        saveLoveList()
        saveFavoriteList()
        saveFavoriteGenres()
    }
    
    // MARK: Methods for managing Love List
    
    func loadLoveList() {
        
        if let mList = NSKeyedUnarchiver.unarchiveObjectWithFile(HMSharedData.movieLoveListArchiveURL.path!) as? [Int: HMMovieInfo] {
            mLoveList = mList
        }
    }
    
    func saveLoveList() -> Bool {
        return NSKeyedArchiver.archiveRootObject(mLoveList, toFile: HMSharedData.movieLoveListArchiveURL.path!)
    }
    
    /**
        Adds a movie to user's love list
        - Param movieObject: Movie that needs to be added to user's love list
    */
    func addToLoveList(movieObject: HMMovieInfo) {
        mLoveList[movieObject.mMovieId] = movieObject
    }
    
    func removeFromLoveList(movieObject: HMMovieInfo) {
        mLoveList.removeValueForKey(movieObject.mMovieId)
    }
    
    /**
        Checks if given movie is in user's love list
        - Param movieObject: Movie that needs to be checked for existence
        - Returns: Boolean value indicating if mobie exist in love list
    */
    func isInLoveList(movieObject: HMMovieInfo) -> Bool {
        if let _ = mLoveList[movieObject.mMovieId] {
            return true
        } else {
            return false
        }
    }
    
    /**
        Returns movie info for a given id it exists in love list
        - Param movieId: Id of the movie whose information is needed
        - Returns: Movie object for the passed movie id.
     */
    func getMovie(movieId: Int) -> HMMovieInfo? {
        return mLoveList[movieId]
    }
    
    func getLovedMovieIds() -> [Int] {
        return [Int](mLoveList.keys)
    }
    
    // MARK: Methods for managing Favorite List
    
    func loadFavoriteList() {
        
        if let mList = NSKeyedUnarchiver.unarchiveObjectWithFile(HMSharedData.movieFavoriteListArchiveURL.path!) as? [Int: HMMovieInfo] {
            mFavoriteList = mList
        }
    }
    
    func saveFavoriteList() -> Bool {
        return NSKeyedArchiver.archiveRootObject(mFavoriteList, toFile: HMSharedData.movieFavoriteListArchiveURL.path!)
    }
    
    /**
        Adds a movie to user's favorite list
        - Param movieObject: Movie that needs to be added to user's favorite list
     */
    func addToFavoriteList(movieObject: HMMovieInfo) {
        mFavoriteList[movieObject.mMovieId] = movieObject
    }
    
    func removeFromFavoriteList(movieObject: HMMovieInfo) {
        mFavoriteList.removeValueForKey(movieObject.mMovieId)
    }
    
    /**
        Removes all movies from favorite list that has the given genre
        - Param genre: Genre of the movie that user's wants to remove from favorite list
     */
    func removeFromFavoriteListWithGenre(genre: String) {
        
        for (id, movieObject) in mFavoriteList {
            if movieObject.mFavoriteCateogry == genre {
                mFavoriteList.removeValueForKey(id)
            }
        }
        
    }
    
    func isInFavoriteList(movieObject: HMMovieInfo) -> Bool {
        if let _ = mFavoriteList[movieObject.mMovieId] {
            return true
        } else {
            return false
        }
    }
    
    
    
    func getFavoriteMovie(movieId: Int) -> HMMovieInfo? {
        return mFavoriteList[movieId]
    }
    
    func getFavoriteMovieIds() -> [Int] {
        return [Int](mFavoriteList.keys)
    }
    
    func getFavoriteMoviesInGenre(genre: String) -> [HMMovieInfo] {
        var movies: [HMMovieInfo] = []
        
        for (_, movie) in mFavoriteList {
            if movie.mFavoriteCateogry == genre {
                movies.append(movie)
            }
        }
        return movies
    }

    
    //MARK: Methods for managing Favorite Genre List
    
    func loadFavoriteGenres() {
        if let mList = NSKeyedUnarchiver.unarchiveObjectWithFile(HMSharedData.movieFavoriteGenreArchiveURL.path!) as? [String] {
            mFavoriteGenreList = mList
        }
    }
    
    func saveFavoriteGenres() -> Bool {
        return NSKeyedArchiver.archiveRootObject(mFavoriteGenreList, toFile: HMSharedData.movieFavoriteGenreArchiveURL.path!)
    }
    
    /**
        Adds a given genre to favorite genre type list
        - Param favoriteName: Name of the genere that user wish to add it favorite genre list
     */
    func addToFavoriteGenres(favoriteName: String) {
        mFavoriteGenreList.append(favoriteName)
    }
    
    func removeFromFavoriteGenres(favoriteName: String) {
        if let index = mFavoriteGenreList.indexOf(favoriteName) {
            mFavoriteGenreList.removeAtIndex(index)
        }
    }
    
    func removeFavoriteGenreAt(index: Int) {
        removeFromFavoriteListWithGenre(mFavoriteGenreList[index])
        mFavoriteGenreList.removeAtIndex(index)
    }
    
    func numberOfFavoriteGenres() -> Int {
        return mFavoriteGenreList.count
    }
    
    func renameFavoriteGenreAt(index: Int, newName: String) {
        mFavoriteGenreList[index] = newName
    }
    
    func favoriteGenreAt(index: Int) -> String {
        if index < mFavoriteGenreList.count {
            return mFavoriteGenreList[index]
        }
        return ""
    }
}
