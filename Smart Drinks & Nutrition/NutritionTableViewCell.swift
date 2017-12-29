//
//  NutritionTableViewCell.swift
//  Smart Drinks & Nutrition
//
//  Created by Phanidhar Mothukuri on 9/8/17.
//  Copyright © 2017 TechSoft,Inc. All rights reserved.
//

import UIKit

class NutritionTableViewCell: UITableViewCell, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
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
    var customerCount = 0
    
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
        numberOfCustomersPicker.delegate = self
        truckDatePicker.minimumDate = Date()
        truckDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        // Initialization code
    }

    @IBAction func requestTapped(_ sender: Any) {
        if (nameTextField.text!.removingWhitespaces().count != 0 && addressTextField.text.removingWhitespaces().count != 0 && dateField.text!.removingWhitespaces().count != 0 ) {
            delegate?.didPressedRequestTruck(sender: self)
        }else{
            print(nameTextField.text!.removingWhitespaces().count,addressTextField.text.removingWhitespaces().count,dateField.text!.removingWhitespaces().count)
            // throw alert.
            delegate?.showAlert()
        }
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
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == dateField {
            return false; //do not show keyboard nor cursor
        }
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            return 10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 9{
            return "\(row+1)+"
        }else{
          return String(row+1)
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == numberOfCustomersPicker{
            if row == 9{
                numberOfCustomerField.text = "\(row+1)+"
            }else{
                numberOfCustomerField.text = "\(row+1)"
            }
        }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateField.text = dateFormatter.string(from:sender.date)
    }

}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespacesAndNewlines).joined()
    }

}
