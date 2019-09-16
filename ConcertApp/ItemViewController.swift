//
//  ItemViewController.swift
//  ConcertApp
//
//  Created by Vitalik on 8/26/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UIScrollViewDelegate {
    

    var imageName: String?
    var timer = Timer()
    var counter = 0
    var images :  [UIImage] = []
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var img: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        scrollView.delegate = self
        
        
        if let name = imageName {
            self.img.image = UIImage(named: name)
        }
        
    
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = 4
        scrollView.delegate = self
        
        
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(images.count)), height: scrollView.frame.size.height)
        
        scrollView.delegate = self
        
        pageControl.numberOfPages = images.count
        view.bringSubviewToFront(pageControl)
        
        
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.img
    }
    
    //Limit of zoom image
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale > 1 {
            if let image  = img.image {
                let ratioW = img.frame.width / image.size.width
                let ratioH = img.frame.width / image.size.width
                let ratio = ratioW < ratioH ? ratioW : ratioH
                let newWidth = image.size.width * ratio
                let newHeight = image.size.height * ratio
                let conditionLeft = newWidth*scrollView.zoomScale > img.frame.width
                let left = 0.5 * (conditionLeft ? newWidth - img.frame.width : (scrollView.frame.width - scrollView.contentSize.width))
                let conditionTop = newHeight*scrollView.zoomScale > img.frame.height
                let top = 0.5 * (conditionTop ? newHeight - img.frame.height: (scrollView.frame.height - scrollView.contentSize.height))

                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = .zero
        }
    }
    
    
   // Page Control
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x/scrollView.frame.width

        pageControl.currentPage = Int(page)
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
//        pageControl.currentPage = Int(pageNumber)
//
//
//    }
//
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        timer.invalidate()
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        timer = Timer.init(timeInterval: 3, target: self, selector: #selector(changeImage), userInfo: nil, repeats: false)
//    }
    
    
//
//    @objc func changeImage() {
//
//        if counter == images.count {
//            counter = 0
//        }
//        if counter < images.count {
//            let index = IndexPath.init(item: counter, section: 0)
//            self.eventC
//            eventCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
//            pageControl.currentPage = counter
//            counter += 1
//
//        } else {
//            counter = 1
//            let index = IndexPath.init(item: counter, section: 0)
//            self.eventCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
//            pageControl.currentPage = counter
//            counter = 1
//
//        }
//
//    }
    
    
    
    
    
}



    

