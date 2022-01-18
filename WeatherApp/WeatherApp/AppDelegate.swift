//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Yasmin Tahira on 17/01/22.
//

import UIKit
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var googleAPIKey = "AIzaSyCN4nNFGlf2ghjvHnz9cnKkN7RxeDDQBDc"
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey(googleAPIKey)
        GMSPlacesClient.provideAPIKey(googleAPIKey)

        return true
    }
}

