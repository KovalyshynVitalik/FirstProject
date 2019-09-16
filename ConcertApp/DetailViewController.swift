//
//  DetailViewController.swift
//  ConcertApp
//
//  Created by Vitalik on 8/16/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit
import UPCarouselFlowLayout

class DetailViewController: UIViewController, UITextViewDelegate {
    
    
    
    var eventImageNames: ConcertDetails? {
        didSet {
            
        }
    }
    
    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var eventCollectionLayout: UICollectionViewFlowLayout!
    
    
    
    var imgArray: [UIImage] = []
    
    var timer = Timer()
    var counter = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        guard let item = eventImageNames else { return }
        for imageName in item.concertImageNames {
            if let image = UIImage(named: imageName) {
                imgArray.append(image)
            }
        }
        
        setUpUI()
        

        textSetup()
        setUpLayout()
        
        pageView.numberOfPages = imgArray.count
        pageView.currentPage = 0
        
        
//        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(changeImage), userInfo: nil, repeats: true)
//        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
//            self.changeImage()
//        })
        
    }
    
    
    @objc func changeImage() {
        
        if counter == imgArray.count {
            counter = 0
        }
        if counter < imgArray.count {
            let index = IndexPath.init(item: counter, section: 0)
            self.eventCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
            
        } else {
            counter = 1
            let index = IndexPath.init(item: counter, section: 0)
            self.eventCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
            
        }
        
    }
    
    func setUpLayout() {
        
        
        let flowLayout = UPCarouselFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: eventCollectionView.frame.size.height)
        flowLayout.scrollDirection = .horizontal
        flowLayout.sideItemScale = 0.8
        flowLayout.sideItemAlpha = 0.5
        flowLayout.spacingMode = .fixed(spacing: 42)
        self.eventCollectionView.collectionViewLayout = flowLayout
    }
    
    func textSetup() {
        self.textView.text = self.eventImageNames?.concertInfo
    }
    
    func setUpUI() {
        self.lbl.text = self.eventImageNames?.concertName
    }
    
    
    
    
    @objc func openFullScreenImageViewController(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let itemViewController = storyBoard.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
        guard let images = self.eventImageNames?.concertImageNames else { return }
        
        var castedImages = [UIImage]()
        
        images.forEach { (item) in
            if let image = UIImage(named: item) {
                castedImages.append(image)
            }
        }
        
        itemViewController.images = castedImages
        
        
        self.navigationController?.pushViewController(itemViewController, animated: true)
    }
    
    
}



extension DetailViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewEventCell
        
        if let items = self.eventImageNames {
            cell.imageView.image = UIImage(named:  items.concertImageNames[indexPath.row])
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventImageNames?.concertImageNames.count ?? 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let fullScreenView = storyBoard.instantiateViewController(withIdentifier: "FullScreenView") as! FullScreenView
        fullScreenView.images = self.eventImageNames!.concertImageNames
        self.navigationController?.pushViewController(fullScreenView, animated: true)
    }

    
    
}


