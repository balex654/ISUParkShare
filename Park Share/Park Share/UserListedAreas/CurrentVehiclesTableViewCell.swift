//
//  CurrentVehiclesTableViewCell.swift
//  Park Share
//
//  Created by Ben Alexander on 11/12/20.
//

import UIKit

class CurrentVehiclesTableViewCell: UITableViewCell {

    @IBOutlet weak var makeAndModel: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var plateNumber: UILabel!
    @IBOutlet weak var username: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
