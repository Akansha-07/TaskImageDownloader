//
//  UIImageViewExtension.swift
//  AppStreetTask
//
//  Created by Akansha Srivastava on 01/06/19.
//  Copyright © 2019 Akansha Srivastava. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        
        if let url = NSURL(string: urlString) {
            
            let request = NSURLRequest(url: url as URL)
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) { [weak self] (response, data, error) in
                if let imageData = data as NSData? {
                    self?.image = UIImage(data: imageData as Data)
                }
            }
        }
    }
}

