//
//  RentedAreasTableViewCell.swift
//  Park Share
//
//  Created by Ben Alexander on 11/12/20.
//

import UIKit

class RentedAreasTableViewCell: UITableViewCell {

    @IBOutlet weak var address: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        address.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
