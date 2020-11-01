//
//  ParkingAreaTableViewCell.swift
//  Park Share
//
//  Created by Ben Alexander on 11/1/20.
//

import UIKit

class ParkingAreaTableViewCell: UITableViewCell {

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var numSpots: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var notes: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        address.sizeToFit()
        notes.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
