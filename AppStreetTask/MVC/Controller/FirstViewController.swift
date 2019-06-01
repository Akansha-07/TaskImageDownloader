//
//  ViewController.swift
//  AppStreetTask
//
//  Created by Akansha Srivastava on 01/06/19.
//  Copyright © 2019 Akansha Srivastava. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    //MARK: -IBOutlets
    @IBOutlet weak var imgCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var lblSearch: UILabel!
    
    //MARK: -Properties
    var arrPhotos = [Photos]()
    var model: ImageDataModel?
    var pageCount = 1
    var collectionWidth: CGFloat = 100.0
    var isNewDataLoading: Bool = false
    var dataSource: CollectionViewDataSource? {
        didSet {
            imgCollectionView.dataSource = dataSource
            imgCollectionView.delegate = dataSource
        }
    }
    
    //MARK: -LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        loader.isHidden = true
        lblSearch.isHidden = false
        searchBar.layer.cornerRadius = 10.0
        setToolBar()
    }
    
    //Set up CollectionView
    fileprivate func setUpCollectionView() {
        
        let cellId = CollectionViewCell.imageCollectionCell.rawValue
        dataSource = CollectionViewDataSource(items: nil, collectionView: imgCollectionView, cellIdentifier: cellId, cellHeight: collectionWidth, cellWidth: collectionWidth, minimumLineSpacing: 10.0, minimumInteritemSpacing: 0.0)
        dataSource?.items = arrPhotos
        dataSource?.configureCellBlock = { [weak self] (cell,item,indexpath) in
            
            guard let strUrl = self?.arrPhotos[indexpath.row].imgUrl else {
                return
            }
            (cell as? ImageCollectionCell)?.imgView.imageFromUrl(urlString: strUrl)
        }
        dataSource?.aRowSelectedListener = { [weak self] (indexpath) in
            
            guard let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "DetailImageVC") as? DetailImageVC else {return}
            
            UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseInOut, animations: {
                self?.view.alpha = 1
                vc.strUrl = self?.arrPhotos[indexpath.row].imgUrl
                self?.navigationController?.pushViewController(vc, animated: true)
                
            })
        }
        dataSource?.scrollViewListener = { [weak self] (scrollView) in
            
            if scrollView == self?.imgCollectionView{
                
                if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
                {
                    if !(self?.isNewDataLoading ?? false){
                        
                        self?.isNewDataLoading = true
                        self?.pageCount += 1
                        self?.apiToGetDetails(text: self?.searchBar.text)
                    }
                }
            }
        }
    }
    
    //Set CollectionView Width
    fileprivate func setCollectionWidth(value: CGFloat) {
        guard let width = imgCollectionView.frame.size.width as? CGFloat else {return}
        
        collectionWidth = (width)/value
        dataSource?.cellWidth = (width)/value
        dataSource?.cellHeight = (width)/value
        imgCollectionView.reloadData()
    }
    
    //Action Sheet
    fileprivate func openActionSheet() {
        
        let alert = UIAlertController(title: "Switch images", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "2 images", style: .default, handler: { [weak self](selectImage) in
            self?.setCollectionWidth(value: 2.0)
            
        }))
        
        alert.addAction(UIAlertAction(title: "3 images", style: .default, handler: { [weak self] (selectImage) in
            self?.setCollectionWidth(value: 3.0)
        }))
        
        alert.addAction(UIAlertAction(title: "4 images", style: .default, handler: { [weak self] (selectImage) in
            self?.setCollectionWidth(value: 4.0)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: -UIAction
    @IBAction func btnChooseImages(sender: UIButton) {
        openActionSheet()
    }
}
extension FirstViewController {
    
    //api Get Details
    func apiToGetDetails(text: String?) {
        loader.isHidden = false
        lblSearch.isHidden = true
        if self.model?.text != text {
            self.arrPhotos.removeAll()
            self.pageCount = 1
        }
        let url = ApiManager.shared.flickrURLFromParameters(searchString: text ?? "")
        
        var parseUrl = URLComponents(string: url.absoluteString)!
        
        parseUrl.queryItems = [
            URLQueryItem(name: "page", value: "\(pageCount)")
        ]
        
        ApiManager.shared.sendRequest(url.absoluteString, params: nil) {[weak self] (isSuccess, dictResponse) in
            
            if isSuccess {
                DispatchQueue.main.async {
                    self?.loader.startAnimating()
                    
                    if let data = dictResponse as? [String: Any] {
                        self?.model = ImageDataModel(dict: data)
                        self?.model?.text = text!
                        if self?.model?.photos?.pages != 0 {
                            self?.model?.photos?.photos.forEach({ (item) in
                                self?.arrPhotos.append(item)
                            })
                            
                        } else {
                            self?.arrPhotos.removeAll()
                            self?.pageCount = 1
                            self?.lblSearch.isHidden = false
                            self?.lblSearch.text = "No image found"
                        }
                        self?.dataSource?.items = self?.arrPhotos
                        self?.loader.isHidden = true
                        self?.isNewDataLoading = false
                        self?.imgCollectionView.reloadData()
                    }
                }
            } else {
                self?.loader.isHidden = true
                self?.lblSearch.isHidden = false
                self?.lblSearch.text = "No image found"
                
            }
            
        }
    }
}
//MARK: -UISearchBar Delegate
extension FirstViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        apiToGetDetails(text: searchBar.text)
    }
    
    func setToolBar() {
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelClicked))
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.doneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([cancelBarButton,spaceButton,doneBarButton], animated: false)
        toolBar.sizeToFit()
        searchBar.inputAccessoryView = toolBar
    }
    
    @objc func doneClicked() {
        searchBar.resignFirstResponder()
        apiToGetDetails(text: searchBar.text)
    }
    
    @objc func cancelClicked() {
        lblSearch.isHidden = false
        searchBar.resignFirstResponder()
    }
}
