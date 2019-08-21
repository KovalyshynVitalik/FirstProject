//
//  DetailViewController.swift
//  ConcertApp
//
//  Created by Vitalik on 8/16/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate{
    
    var event: Event?
    
    var eventImageNames = [Concert]() {
        didSet {
            self.eventCollectionView.reloadData()
        }
    }

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var eventCollectionView: UICollectionView!
    @IBOutlet weak var textView: UITextView!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setUpUI()
        self.eventImageNames = readJSONFromFile(fileName: "events")!
        print()
        
        textSetup()

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
                // Getting data from JSON file using the file URL
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
