//
//  ResizedCollectionViewCell.swift
//  ConcertApp
//
//  Created by Vitalik on 9/7/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit


class ResizedCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {

    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var img: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
      
        self.scrollView.minimumZoomScale = 1
        self.scrollView.maximumZoomScale = 4
        scrollView.delegate = self
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
}
