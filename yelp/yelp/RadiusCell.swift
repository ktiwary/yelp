//
//  RadiusCell.swift
//  yelp
//
//  Created by Kushagra Kumar Tiwary on 9/21/14.
//  Copyright (c) 2014 myorg. All rights reserved.
//

import UIKit

class RadiusCell: UITableViewCell {

    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var radiusSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
