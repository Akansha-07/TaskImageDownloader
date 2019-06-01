//
//  ScrollViewDataSouce.swift
//  AppStreetTask
//
//  Created by Akansha Srivastava on 01/06/19.
//  Copyright © 2019 Akansha Srivastava. All rights reserved.
//

import Foundation
import UIKit

typealias ScrollViewScrolled = (UIScrollView) -> ()
typealias WillBeginDragginBlock = (_ scrollView : UIScrollView) -> ()
typealias DidEndDraggingBlock = (_ scrollView : UIScrollView) -> ()
typealias DidEndDeceleratingBlock = (_ scrollView : UIScrollView) -> ()
typealias CollectionViewScollViewDidScroll = (_ scrollView : UIScrollView) -> ()


class ScrollViewDataSource: NSObject {
    
    var scrollViewDidScroll: CollectionViewScollViewDidScroll?
    var willBeginDraggingListener : WillBeginDragginBlock?
    var didEndDraggingListener : DidEndDraggingBlock?
    var didEndDeceleratingBlock : DidEndDeceleratingBlock?
    var scrollViewDragValue : CGFloat = 0
    var scrollViewListener : ScrollViewScrolled?
    
    
    @objc func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let block = scrollViewDidScroll else { return }
        block(scrollView)
    }
    
    @nonobjc func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        scrollViewDragValue = scrollView.contentOffset.y
        guard let block = willBeginDraggingListener else { return }
        block(scrollView)
        
    }
    
    @nonobjc func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let block = didEndDraggingListener else { return }
        block(scrollView)
    }
    
    
    @objc func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let block = scrollViewListener {
            block(scrollView)
        }
    }
    
}
