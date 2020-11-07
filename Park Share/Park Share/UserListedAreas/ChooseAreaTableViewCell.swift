//
//  ChooseAreaTableViewCell.swift
//  Park Share
//
//  Created by Ben Alexander on 11/7/20.
//

import UIKit

class ChooseAreaTableViewCell: UITableViewCell {

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
