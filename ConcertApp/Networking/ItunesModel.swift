//
//  ItunesModel.swift
//  ConcertApp
//
//  Created by Vitalik on 9/14/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import Foundation

struct ItunesModel: Decodable {
    var resultCount: Int?
    var results: [Item]?
}

struct Item: Decodable {
    var trackId:Int?
    var artworkUrl100: String?
}
