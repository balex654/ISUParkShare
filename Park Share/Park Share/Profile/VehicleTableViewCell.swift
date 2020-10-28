//
//  VehicleTableViewCell.swift
//  Park Share
//
//  Created by Ben Alexander on 10/28/20.
//

import UIKit

class VehicleTableViewCell: UITableViewCell {

    @IBOutlet weak var makeModel: UILabel!
    @IBOutlet weak var color: UILabel!
    @IBOutlet weak var plateNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
