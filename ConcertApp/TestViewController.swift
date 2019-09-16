//
//  TestViewController.swift
//  ConcertApp
//
//  Created by Vitalik on 9/14/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        postRequest(with: "Dzidzio") { (model) in
            if let first = model.results?.first {
                if let imageString = first.artworkUrl100,let ulrString = URL(string: imageString) {
                    SDWebImageManager.shared.loadImage(with: ulrString, options: .highPriority, progress: nil, completed: { (image, _, _, _, _, _) in
                        
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                    })
                }
            }
        }
    }
    
    func postRequest(with artistName: String,completion: @escaping(ItunesModel) -> Void) {
        
        guard let url = URL(string:"https://itunes.apple.com/search?media=music&entity=song&term=\(artistName)&limit=1") else { return }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            do {
                guard let data = response.data else { return }
                let instance = try JSONDecoder().decode(ItunesModel.self, from: data)
                completion(instance)
            } catch {
                print("ERROR")
            }
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
}
