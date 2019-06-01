//
//  ImageDataModel.swift
//  AppStreetTask
//
//  Created by Akansha Srivastava on 01/06/19.
//  Copyright © 2019 Akansha Srivastava. All rights reserved.
//

import Foundation
import UIKit

struct ImageDataModel {
  
    var photos: PhotosModal?
    var text = String()
    init() {}
    
    init(dict: [String: Any]) {
        
        if let photosDict = dict["photos"] as? [String: Any] {
             self.photos = PhotosModal(dict: photosDict)
        }
    }

}

struct PhotosModal {
    var page : Int?
    var pages: Int?
    var photos = [Photos]()
    
    init() {}
    
    init(dict: [String: Any]) {
        
        if let photosArray = dict["photo"] as? [[String: Any]] {
            
            for each in photosArray {
                let model = Photos(json: each)
                self.photos.append(model)
            }
        }
        if let page = dict["page"] as? Int {
            self.page = page
        }
        if let pages = dict["pages"] as? Int {
            self.pages = pages
        }

    }
    
}

struct Photos {
    
    var imgUrl = String()
    
    init(json: [String: Any]) {
        
        if let url = json["url_m"] as? String {
            self.imgUrl = url
        }
        
    }
}
