//
//  DetailViewController.swift
//  ConcertApp
//
//  Created by Vitalik on 8/16/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    

    
   
    
    public var images: Concert?
    

    var event: Event?
    
    var eventImageNames = [Concert]() {
        didSet {
            self.eventCollectionView.reloadData()
        }
    }

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pageView: UIPageControl!
    
    
    
    let imgArray = [UIImage(named: "Beyonce"),
                    UIImage(named: "eminem"),
                    UIImage(named: "Drake")]
    
    var timer = Timer()
    var counter = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
      
        
       
        setUpUI()
        self.eventImageNames = readJSONFromFile(fileName: "events")!
        print()
        
        textSetup()
        
        pageView.numberOfPages = imgArray.count
        pageView.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)

        }

    }
    
    
   @objc func changeImage() {
    
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
   
    func textSetup() {
        self.textView.text = event?.textName
    }
        
    func setUpUI() {
        self.lbl.text = event?.name
    }
    
    
    
    
    
    
    
    @objc func openFullScreenImageViewController(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let fullScreenImageViewController = storyBoard.instantiateViewController(withIdentifier: "FullScreenImageViewController") as! FullScreenImageViewController
        fullScreenImageViewController.imageName = event?.imageName ?? ""
        self.navigationController?.pushViewController(fullScreenImageViewController, animated: true)
    }
    
    func readJSONFromFile(fileName: String) -> [Concert]? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let fileUrl = URL(fileURLWithPath: path)
                
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
                
                let model = try JSONDecoder().decode([Concert].self, from: data)
                return model
            } catch { }
        }
        return nil
    }
    
    
}



extension DetailViewController: UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventImageNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewEventCell
        if let imageName = eventImageNames[indexPath.row].imageName {
            cell.imageView.image = UIImage(named: imageName)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let fullScreenImageViewController = storyBoard.instantiateViewController(withIdentifier: "FullScreenImageViewController") as! FullScreenImageViewController
        fullScreenImageViewController.imageName = eventImageNames[indexPath.row].imageName!
        self.navigationController?.pushViewController(fullScreenImageViewController, animated: true)
    }
    
    
    
}
