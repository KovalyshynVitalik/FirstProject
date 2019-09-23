//
//  ArtistModel.swift
//  ConcertApp
//
//  Created by Vitalik on 9/2/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import Foundation

struct ArtistModel {
    var artistName: String
    var imageName: String
    var concertDetails: ConcertDetails
    var imageURLString: String?
}


struct ConcertDetails {
    var concertName:       String
    var concertInfo:       String
    var concertImageNames: [String]
}
