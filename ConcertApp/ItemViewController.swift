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
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var img: UIImageView!
    
    var images: [String] = ["Beyonce", "eminem", "Drake"]
    var frame = CGRect(x: 50, y: 50, width: 150, height: 0)
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        if let name = imageName {
            self.img.image = UIImage(named: name)
        }
        
   
        for index in 0..<images.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            
            let imgView = UIImageView(frame: frame)
            imgView.image = UIImage(named: images[index])
            self.scrollView.addSubview(imgView)
            
            
        }

        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(images.count)), height: scrollView.frame.size.height)
        scrollView.delegate = self

        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.img
    }
    
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }

}
