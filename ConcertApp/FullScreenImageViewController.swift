//
//  FullScreenImageViewController.swift
//  ConcertApp
//
//  Created by Vitalik on 8/17/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit

class FullScreenImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageName: String?

    @IBOutlet weak var eventScrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        eventScrollView.delegate = self
        self.eventScrollView.minimumZoomScale = 1.0
        self.eventScrollView.maximumZoomScale = 6.0
        
        if let name = imageName {
            self.imageView.image = UIImage(named: name)
        }
        
        
    
            
        
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    

}
