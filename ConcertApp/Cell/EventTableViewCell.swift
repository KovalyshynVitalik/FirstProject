//
//  IventTableViewCell.swift
//  ConcertApp
//
//  Created by Misha on 8/5/19.
//  Copyright © 2019 Misha. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {

    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    


    
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

