//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Yasmin Tahira on 17/01/22.
//

import Foundation

class NetworkManager {

    /// Get Data From Server Completion block
    internal typealias GetDataFromServerCompletionClosure = (_ data:Data?, _ response: URLResponse?, _ error: Error?) -> Void

    func makeWebAPICall(request: NSMutableURLRequest, withCompletionBlock completion: @escaping GetDataFromServerCompletionClosure) {
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            completion(data,response,error)
        })
        task.resume()
    }
}
