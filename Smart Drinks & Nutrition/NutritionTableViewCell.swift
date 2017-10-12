//
//  NutritionTableViewCell.swift
//  Smart Drinks & Nutrition
//
//  Created by Phanidhar Mothukuri on 9/8/17.
//  Copyright © 2017 TechSoft,Inc. All rights reserved.
//

import UIKit

class NutritionTableViewCell: UITableViewCell {
    @IBOutlet weak var nutritionDetailText: UILabel!

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextView!
    
    @IBOutlet weak var notes: UITextView!
    
    @IBOutlet weak var requestButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addressTextField.layer.borderWidth = 0.5
        addressTextField.layer.cornerRadius = 5
        addressTextField.layer.borderColor = UIColor.lightGray.cgColor
        notes.layer.borderColor = UIColor.lightGray.cgColor
        notes.layer.borderWidth = 0.5
        notes.layer.cornerRadius = 5
        requestButton.layer.cornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
