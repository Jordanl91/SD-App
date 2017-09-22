//
//  DrinksTableViewCell.swift
//  Smart Drinks & Nutrition
//
//  Created by Phanidhar Mothukuri on 9/20/17.
//  Copyright © 2017 TechSoft,Inc. All rights reserved.
//

import UIKit

class DrinksTableViewCell: UITableViewCell {

    @IBOutlet weak var drinkTitle: UILabel!
    
    @IBOutlet weak var drinkDescription: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
