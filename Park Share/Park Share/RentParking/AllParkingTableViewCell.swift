//
//  AllParkingTableViewCell.swift
//  Park Share
//
//  Created by Ben Alexander on 11/9/20.
//

import UIKit

class AllParkingTableViewCell: UITableViewCell {

    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var spotsAvailable: UILabel!
    @IBOutlet weak var spotsTaken: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        address.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
