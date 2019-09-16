//
//  RequestsManager.swift
//  ConcertApp
//
//  Created by Vitalik on 9/15/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import Foundation
import Alamofire



class RequestsManager {
    
    private init() {}
    
    static let shared = RequestsManager()
    
    func getImageURLString(with artistName: String, completion: @escaping(String) -> Void) {
        
        guard let url = URL(string:"https://itunes.apple.com/search?media=music&entity=song&term=\(artistName)&limit=1") else { return }
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            do {
                guard let data = response.data else { return }
                let instance = try JSONDecoder().decode(ItunesModel.self, from: data)
                
                guard let unwrappedArtworkURL = instance.results?.first?.artworkUrl100 else { return }
                
                completion(unwrappedArtworkURL)
            } catch {
                print("ERROR")
            }
        }
        
    }
    
}
