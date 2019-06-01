//
//  Constants.swift
//  AppStreetTask
//
//  Created by Akansha Srivastava on 01/06/19.
//  Copyright © 2019 Akansha Srivastava. All rights reserved.
//

import Foundation
import UIKit

//Collection view cell
enum CollectionViewCell: String {
    
    case imageCollectionCell = "ImageCollectionCell"
}

struct FlickrURLParams {
    static let APIScheme = "https"
    static let APIHost = "api.flickr.com"
    static let APIPath = "/services/rest"
}

struct FlickrAPIKeys {
    static let SearchMethod = "method"
    static let APIKey = "api_key"
    static let Extras = "extras"
    static let ResponseFormat = "format"
    static let DisableJSONCallback = "nojsoncallback"
    static let SafeSearch = "safe_search"
    static let Text = "text"
}

struct FlickrAPIValues {
    static let SearchMethod = "flickr.photos.search"
    static let APIKey = "8b1951245dadab71d7842154df863fe0"
    static let ResponseFormat = "json"
    static let DisableJSONCallback = "1"
    static let MediumURL = "url_m"
    static let SafeSearch = "1"
}
