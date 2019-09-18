//
//  IventTableViewCell.swift
//  ConcertApp
//
//  Created by Misha on 8/5/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
        self.img.image = nil
        self.lbl.text = nil
    }
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
}

