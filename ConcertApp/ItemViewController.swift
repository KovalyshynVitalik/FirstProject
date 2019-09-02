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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        
        if let name = imageName {
            self.img.image = UIImage(named: name)
        }
        
        
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        
        
        
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.img
    }
    
}
