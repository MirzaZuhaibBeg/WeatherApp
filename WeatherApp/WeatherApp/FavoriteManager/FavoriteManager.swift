//
//  FavoriteManager.swift
//  WeatherApp
//
//  Created by Yasmin Tahira on 17/01/22.
//

import UIKit

class FavoriteManager {

    static let sharedInstance = FavoriteManager()
    
    //MARK: Internal Methods
    
    internal func markLocationAsFavorite(locationInfo: LocationInfo?) {
        guard let locationInfo = locationInfo else {
            return
        }
        
        // get favorite list
        var favorites: [[String: Any]] = [[String: Any]]()
        if let favoriteList = UserDefaults.standard.object(forKey: Constants.favoriteList) as? [[String: Any]] {
            favorites = favoriteList
        }
        
        // check if location is already favorite
        var indexFavInfo: Int?
        for (index, favInfo) in favorites.enumerated() {
            if let favInfoPlaceID = favInfo[Constants.placeID] as? String, let placeID = locationInfo.placeID, (favInfoPlaceID == placeID) {
                indexFavInfo = index
            }
        }

        guard indexFavInfo == nil else {
            return
        }
        
        // add favorite item
        var favDict = [String: Any]()
        if let placeID = locationInfo.placeID {
            favDict[Constants.placeID] = placeID
        }
        if let title = locationInfo.title {
            favDict[Constants.title] = title
        }
        favorites.append(favDict)
        
        // save new favorites
        UserDefaults.standard.set(favorites, forKey: Constants.favoriteList)
        UserDefaults.standard.synchronize()
    }
    
    internal func deleteLocationFromFavoriteList(favoriteInfo: FavoriteInfo?) {
        guard let favoriteInfo = favoriteInfo, let placeID = favoriteInfo.placeID else {
            return
        }
        
        // get favorite list
        var favorites: [[String: Any]] = [[String: Any]]()
        if let favoriteList = UserDefaults.standard.object(forKey: Constants.favoriteList) as? [[String: Any]] {
            favorites = favoriteList
        }
        
        var indexFavInfo: Int?
        for (index, favInfo) in favorites.enumerated() {
            if let favInfoPlaceID = favInfo[Constants.placeID] as? String, (favInfoPlaceID == placeID) {
                indexFavInfo = index
            }
        }
        
        // remove selected favorite
        if let indexFavInfo = indexFavInfo {
            favorites.remove(at: indexFavInfo)
        }
        
        // save new favorites
        UserDefaults.standard.set(favorites, forKey: Constants.favoriteList)
        UserDefaults.standard.synchronize()
    }
    
    internal func getAllFavorites() -> [FavoriteInfo] {
        
        var favoriteInfoArray = [FavoriteInfo]()
        
        guard let favoriteList = UserDefaults.standard.object(forKey: Constants.favoriteList) as? [[String: Any]] else {
            return favoriteInfoArray
        }
        
        for favorite in favoriteList {
            
            var favoriteInfo = FavoriteInfo()
            
            if let placeID = favorite[Constants.placeID] as? String {
                favoriteInfo.placeID = placeID
            }
            if let title = favorite[Constants.title] as? String{
                favoriteInfo.title = title
            }
            
            favoriteInfoArray.append(favoriteInfo)
        }

        return favoriteInfoArray
    }
}
