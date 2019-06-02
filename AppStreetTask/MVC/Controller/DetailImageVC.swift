//
//  DetailImageVC.swift
//  AppStreetTask
//
//  Created by Akansha Srivastava on 01/06/19.
//  Copyright © 2019 Akansha Srivastava. All rights reserved.
//

import UIKit

class DetailImageVC: UIViewController {

    //MARK: -IBOutlets
    @IBOutlet weak var imgView : UIImageView!
    
    //MARK: -Properties
    var strUrl: String?
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imgView.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseInOut, animations: {
            self.imgView.alpha = 1
            guard let strUrl = self.strUrl else {
                return
            }
            self.imgView.image = ApiManager.shared.downloadImageAsynchronously(strUrl, imageView: self.imgView, placeHolderImage: #imageLiteral(resourceName: "Img-1"), contentMode: .scaleAspectFill)
        })
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }
}
