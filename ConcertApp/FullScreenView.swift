//
//  FullScreenView.swift
//  ConcertApp
//
//  Created by Vitalik on 9/7/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout

class FullScreenView: UIViewController {
    
    
    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Properties
    let cellIdentifier = "ResizedCollectionViewCell"
    var products = [ProductDto]()
    public var images: [String]?
    
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpLayout()
        
        
        self.collectionView.register(UINib(nibName:"ResizedCollectionViewCell" , bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func setUpLayout() {
        
        
        let flowLayout = UPCarouselFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: collectionView.frame.size.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sideItemScale = 0.8
        flowLayout.sideItemAlpha = 0.5
        flowLayout.spacingMode = .fixed(spacing: 42)
        //        flowLayout.spacingMode = .
        self.collectionView.collectionViewLayout = flowLayout
        //        festivalsCollectionView.collectionViewLayout = floawLayout
    }
    
    
}


extension FullScreenView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ResizedCollectionViewCell
        
        if let items = self.images {
            cell.img.image = UIImage(named: items[indexPath.row])
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images?.count ?? 0
        
    }
    
    
    
    
}



