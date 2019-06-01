//
//  APIManager.swift
//  AppStreetTask
//
//  Created by Akansha Srivastava on 01/06/19.
//  Copyright © 2019 Akansha Srivastava. All rights reserved.
//

import Foundation
import UIKit

class ApiManager: NSObject {
    
    static let shared = ApiManager()
    
    func flickrURLFromParameters(searchString: String) -> URL {
        
        // Build base URL
        var components = URLComponents()
        components.scheme = FlickrURLParams.APIScheme
        components.host = FlickrURLParams.APIHost
        components.path = FlickrURLParams.APIPath
        
        // Build query string
        components.queryItems = [URLQueryItem]()
        
        // Query components
        components.queryItems!.append(URLQueryItem(name:FlickrAPIKeys.APIKey, value: FlickrAPIValues.APIKey));
        components.queryItems!.append(URLQueryItem(name: FlickrAPIKeys.SearchMethod, value: FlickrAPIValues.SearchMethod));
        components.queryItems!.append(URLQueryItem(name: FlickrAPIKeys.ResponseFormat, value: FlickrAPIValues.ResponseFormat));
        components.queryItems!.append(URLQueryItem(name: FlickrAPIKeys.Extras, value: FlickrAPIValues.MediumURL));
        components.queryItems!.append(URLQueryItem(name: FlickrAPIKeys.SafeSearch, value: FlickrAPIValues.SafeSearch));
        components.queryItems!.append(URLQueryItem(name: FlickrAPIKeys.DisableJSONCallback, value: FlickrAPIValues.DisableJSONCallback));
        components.queryItems!.append(URLQueryItem(name: FlickrAPIKeys.Text, value: searchString));
        
        return components.url!
    }
    
    
    func sendRequest(_ url: String, params: [String:AnyObject]?, result:@escaping (_ succeeded:Bool, _ response:[String:Any]) -> ()){
        
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "GET" as String
        let urlConfig = URLSessionConfiguration.default
        urlConfig.requestCachePolicy = .returnCacheDataElseLoad
        let session = URLSession(configuration: urlConfig)
        let task = session.dataTask(with: request) {data, response, error in
            
            if(response != nil && data != nil) {
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any] {
                        
                        result(true, json)
                        
                    } else {
                        
                        let strJsonError = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                     
                        result(false, [:])
                    }
                } catch let parseError {
                    
                    let strJsonError = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    result(false, [:])
                }
            } else {
                result(false, [:])
            }
        }
        task.resume()
    }
    
}
