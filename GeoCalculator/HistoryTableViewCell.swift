//
//  HistoryTableViewCell.swift
//  GeoCalculator
//
//  Created by Sahana on 6/1/17.
//  Copyright © 2017 Jonathan Engelsma. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
   

    @IBOutlet weak var destPoint: UILabel!
    
    
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var origPoint: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
