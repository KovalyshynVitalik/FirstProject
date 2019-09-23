//
//  RequestsManager.swift
//  ConcertApp
//
//  Created by Vitalik on 9/15/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import Foundation
//import Alamofire

class RequestsManager {
    
    private init() {}
    
    static let shared = RequestsManager()
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL,completion: @escaping(Data) -> Void) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            completion(data)
        }
    }
}
