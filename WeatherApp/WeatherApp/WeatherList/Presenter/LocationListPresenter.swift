//
//  LocationListPresenter.swift
//  WeatherApp
//
//  Created by Yasmin Tahira on 17/01/22.
//

import UIKit
import GooglePlaces

protocol LocationListPresenterProtocol {
    
    func attachView(_ view: LocationListViewProtocol)

    func searchLocation(textInput: String)
    
    func fetchAllFavorite()
    
    func getWeatherReport(favoriteInfo: FavoriteInfo?) 
}

class LocationListPresenter: LocationListPresenterProtocol {

    weak var delegate: LocationListViewProtocol?
    
    func attachView(_ view: LocationListViewProtocol) {
        self.delegate = view
    }

    func searchLocation(textInput: String) {
                
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        
        let placesClient = GMSPlacesClient()
        placesClient.autocompleteQuery(textInput, bounds: nil, filter: nil) { (results, error) -> Void in
            
            guard error == nil else {
                self.delegate?.populateLocationSearchError()
                return
            }

            var arrayLocation = [LocationInfo]()

            if let results = results {
                
                for result in results {
                    var locationInfo = LocationInfo()
                    locationInfo.title = result.attributedFullText.string
                    locationInfo.placeID = result.placeID
                    arrayLocation.append(locationInfo)
                }
            }
            
            self.delegate?.populateLocationItemArray(locationInfoArray: arrayLocation)
        }
    }
    
    func fetchAllFavorite() {
        let favorites = FavoriteManager.sharedInstance.getAllFavorites()
        self.delegate?.populateFavoriteItemArray(favoriteInfoArray: favorites)
    }

    func getWeatherReport(favoriteInfo: FavoriteInfo?)  {
        guard let favoriteInfo = favoriteInfo, let title = favoriteInfo.title else {
            return
        }
        
        var favInfo = favoriteInfo
        
        ServiceHelper.sharedInstance.getCurrentWeatherAPICall(withLocation: title) { (success, data, error) in
            
            if let data = data as? [String: Any], let current = data["current"] as? [String: Any] {
                
                var weatherReport = ""
                if let temperature = current["temperature"] as? Int {
                    weatherReport.append("Temperature: \(temperature)")
                    weatherReport.append("\n")
                }
                
                if let feelslike = current["feelslike"] as? Int {
                    weatherReport.append("Feels Like: \(feelslike)")
                }
                
                favInfo.weatherReport = weatherReport
            }
            
            DispatchQueue.main.async(execute: {
                self.delegate?.populateWeatherReport(favoriteInfo: favInfo)
            })
        }
    }
}
