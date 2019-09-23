//
//  CollectionViewEventCell.swift
//  ConcertApp
//
//  Created by Vitalik on 8/18/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit

class CollectionViewEventCell: UICollectionViewCell {
    
    var imageName: String?
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let name = imageName {
            self.imageView.image = UIImage(named: name)
        }
    }
    
}
