//
//  ImageCollectionReusableView.swift
//  AppStreetTask
//
//  Created by Akansha Srivastava on 02/06/19.
//  Copyright © 2019 Akansha Srivastava. All rights reserved.
//

import UIKit

class ImageCollectionReusableView: UICollectionReusableView {
   
    @IBOutlet weak var loader: UIActivityIndicatorView!
   
    override func awakeFromNib() {
        loader.startAnimating()
    }
    
}
