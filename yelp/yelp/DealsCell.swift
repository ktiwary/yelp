//
//  DealsCell.swift
//  yelp
//
//  Created by Kushagra Kumar Tiwary on 9/21/14.
//  Copyright (c) 2014 myorg. All rights reserved.
//

import UIKit

class DealsCell: UITableViewCell {

    @IBOutlet weak var dealsLabel: UILabel!
    @IBOutlet weak var dealsSwitch: UISwitch!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
