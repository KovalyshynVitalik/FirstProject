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
    
    var artistDescription: JsonDataImage?
    var collectionViewImages: ResizedCollectionViewCell?
    
    public var images: [String]?
    
    public var imageURLs: [URL?] = []
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        populateUIWithModel()
        
        setUpLayout()
        
        
        self.collectionView.register(UINib(nibName:"ResizedCollectionViewCell" , bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    
    
    func populateUIWithModel() {
    
        if let unwrappedArtistInfo = self.artistDescription {
            if unwrappedArtistInfo.previewURL.isEmpty {
                self.collectionView.reloadData()
            }
        }
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
        
        if let url = self.artistDescription?.previewURL[indexPath.row] {
            RequestsManager.shared.downloadImage(from: url) { (data) in
                DispatchQueue.main.async {
                    cell.img.image = UIImage(data: data)
                }
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.artistDescription?.previewURL.count ?? 0
        
    }
}




