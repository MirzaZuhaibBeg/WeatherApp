//
//  ServiceHelper.swift
//  WeatherApp
//
//  Created by Yasmin Tahira on 17/01/22.
//

import Foundation

public struct ServiceHelperConstant {
    
    public static let KSuccessCode = 200
    
    public static let KAPIKeyValue = "a58355b8cbe9d189ca606de2c832b194"
    
    public static let KGET = "GET"
}

class ServiceHelper {
    
    typealias CompletionBlock = (_ success: Bool, _ data: Any?, _ error: String?) -> Void
    
    typealias ErrorBlock = (_ error: String?) -> Void

    typealias ParseDataCompletionBlock = (_ success: Bool, _ data: Any?, _ error: Error?) -> Void

    static let baseURL = "http://api.weatherstack.com/"
    
    static let KCurrentAPI = "current"

    static let sharedInstance = ServiceHelper()
    
    //MARK: APIs

    func getCurrentWeatherAPICall(withLocation location: String, withCompletionBlock completion: @escaping CompletionBlock){

        let locationString = location.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)

        var parameters = [String:Any]()
        parameters["access_key"] = ServiceHelperConstant.KAPIKeyValue
        parameters["query"] = locationString
        guard let request: NSMutableURLRequest = self.getGETURLRequest(parameters, api: ServiceHelper.KCurrentAPI)  else {
            completion(false,nil,nil)
            return
        }
                
        let networkManager = NetworkManager()
        networkManager.makeWebAPICall(request: request) { [weak self] (data, response, error) in
            if let data = data, let httpResponse = response as? HTTPURLResponse,  httpResponse.statusCode == ServiceHelperConstant.KSuccessCode {
                self?.parseData(withData: data, completionHandler: { (success, data, error) in
                    completion(success, data, error?.localizedDescription)
                })
            } else {
                if let error = error {
                    completion(false, nil, error.localizedDescription)
                } else {
                    completion(false, nil, "Something went wrong")
                }
            }
        }
    }
    
    func getGETURLRequest(_ parameters: [String: Any]?, api: String) -> NSMutableURLRequest? {
        var urlString : String = ServiceHelper.baseURL + api + "?"
        
        // Append parametres for GET API
        if let parameters = parameters {
            var isFirstParam = true
            for (key, object) in parameters {
                if let object = object as? String {
                    if isFirstParam == false {
                        urlString = urlString + "&"
                    }
                    urlString = urlString + key + "=" + object
                    isFirstParam = false
                }
            }
        }
        
        if let url = URL(string: urlString) {
            let request: NSMutableURLRequest = NSMutableURLRequest(url: url)
            request.httpMethod = ServiceHelperConstant.KGET
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            return request
        } else {
            return nil
        }
    }
    
    fileprivate func parseData(withData data: Data, completionHandler: @escaping ParseDataCompletionBlock) {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
            if let json = json {
                
                #if DEBUG
                print("json")
                print(json)

                #else
           
                #endif
                
                completionHandler(true, json, nil)
            } else {
                completionHandler(false, nil, nil)
            }
        } catch let error {
            completionHandler(false, nil, error)
        }
    }
}
