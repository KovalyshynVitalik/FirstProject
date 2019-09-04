//
//  ItemViewController.swift
//  ConcertApp
//
//  Created by Vitalik on 8/26/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit

class ItemViewController: UIViewController, UIScrollViewDelegate {
    var eventImageNames: ConcertDetails? {
        didSet {
            
        }
    }
    
    var imageName: String?
    var timer = Timer()
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var counter = 0
    var images :  [UIImage] = []
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var img: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let item = eventImageNames else { return }
        for imageName in item.concertImageNames {
            if let image = UIImage(named: imageName) {
                images.append(image)
            }
            
        }
      
        
        scrollView.delegate = self
        
        
        if let name = imageName {
            self.img.image = UIImage(named: name)
        }
        
    
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = 4
        scrollView.delegate = self
        
        
        pageControl.numberOfPages = images.count
        for index in 0..<images.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: images)
            self.scrollView.addSubview(imgView)
            
        }
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(images.count)), height: scrollView.frame.size.height)
        
        scrollView.delegate = self
        
        
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.img
    }
    
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
        
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        timer.invalidate()
    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        timer = Timer.init(timeInterval: 3, target: self, selector: #selector(<#T##@objc method#>), userInfo: nil, repeats: false)
//    }
    
    
    
//    @objc func changeImage() {
//    }
    
    
    
    
    
}



    

