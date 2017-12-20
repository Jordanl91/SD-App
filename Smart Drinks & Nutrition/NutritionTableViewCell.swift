//
//  NutritionTableViewCell.swift
//  Smart Drinks & Nutrition
//
//  Created by Phanidhar Mothukuri on 9/8/17.
//  Copyright © 2017 TechSoft,Inc. All rights reserved.
//

import UIKit

class NutritionTableViewCell: UITableViewCell, UITextFieldDelegate {
    @IBOutlet weak var nutritionDetailText: UILabel!

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextView!
    
    @IBOutlet weak var notes: UITextView!
    
    @IBOutlet weak var requestButton: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var dateField: UITextField!
    
    @IBOutlet weak var numberOfCustomerField: UITextField!
    
    @IBOutlet weak var truckDatePicker: UIDatePicker!
    
    @IBOutlet weak var numberOfCustomersPicker: UIPickerView!
    
    @IBOutlet weak var heightForCustomerCountPicker: NSLayoutConstraint!
    
    @IBOutlet weak var heightForDatePicker: NSLayoutConstraint!
    
    weak var delegate:RequestTruckDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        heightForDatePicker.constant = 0
        heightForCustomerCountPicker.constant = 0
        addressTextField.layer.borderWidth = 0.5
        addressTextField.layer.cornerRadius = 5
        addressTextField.layer.borderColor = UIColor.lightGray.cgColor
        notes.layer.borderColor = UIColor.lightGray.cgColor
        notes.layer.borderWidth = 0.5
        notes.layer.cornerRadius = 5
        requestButton.layer.cornerRadius = 5
        dateField.delegate = self
        numberOfCustomerField.delegate = self
        // Initialization code
    }

    @IBAction func requestTapped(_ sender: Any) {
        delegate?.didPressedRequestTruck(sender: self)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dateField{
            heightForDatePicker.constant = 162
        }
        
        if textField == numberOfCustomerField{
            heightForCustomerCountPicker.constant = 162
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == dateField{
            heightForDatePicker.constant = 0
        }
        if textField == numberOfCustomerField{
            heightForCustomerCountPicker.constant = 0
        }
    }

}
