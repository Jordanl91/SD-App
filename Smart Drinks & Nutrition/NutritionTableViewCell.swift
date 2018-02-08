//
//  NutritionTableViewCell.swift
//  Smart Drinks & Nutrition
//
//  Created by Phanidhar Mothukuri on 9/8/17.
//  Copyright © 2017 TechSoft,Inc. All rights reserved.
//

import UIKit

class NutritionTableViewCell: UITableViewCell, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    @IBOutlet weak var nutritionDetailText: UILabel!

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextView!
    
    @IBOutlet weak var notes: UITextView!
    
    @IBOutlet weak var requestButton: UIButton!
    
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var dateField: UITextField!
    
    @IBOutlet weak var numberOfCustomerField: UITextField!
    

    var customerCount = 0
    
    weak var delegate:RequestTruckDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        let pickerView = UIPickerView()
        pickerView.delegate = self
        let truckDatePicker = UIDatePicker()
        addressTextField.layer.borderWidth = 0.5
        addressTextField.layer.cornerRadius = 5
        addressTextField.layer.borderColor = UIColor.lightGray.cgColor
        notes.layer.borderColor = UIColor.lightGray.cgColor
        notes.layer.borderWidth = 0.5
        notes.layer.cornerRadius = 5
        requestButton.layer.cornerRadius = 5
        dateField.delegate = self
        notes.delegate = self
        emailField.delegate = self
        addressTextField.delegate = self
        nameTextField.delegate = self
        numberOfCustomerField.delegate = self
        phoneNumber.delegate = self
//        numberOfCustomersPicker.delegate = self
        truckDatePicker.minimumDate = Date()
        truckDatePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        truckDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        dateField.inputView = truckDatePicker
        numberOfCustomerField.inputView = pickerView
        truckDatePicker.datePickerMode = UIDatePickerMode.date
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.contentView.addGestureRecognizer(tapGesture)
        // Initialization code
    }

    @IBAction func requestTapped(_ sender: Any) {
        if (nameTextField.text!.removingWhitespaces().count != 0 && addressTextField.text.removingWhitespaces().count != 0 && dateField.text!.removingWhitespaces().count != 0 && numberOfCustomerField.text?.removingWhitespaces().count != 0) {
            if emailField.text?.removingWhitespaces().count == 0 {
                delegate?.didPressedRequestTruck(sender: self)
            }else{
                if isValidEmailAddress(emailAddressString: emailField.text!) {
                    delegate?.didPressedRequestTruck(sender: self)
                }else{
                    delegate?.wrongEmailAlert()
                }
            }
        }else{
            print(nameTextField.text!.removingWhitespaces().count,addressTextField.text.removingWhitespaces().count,dateField.text!.removingWhitespaces().count)
            // throw alert.

            delegate?.showAlert()
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        delegate?.dismissKeyboard()
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView
        (_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
            return 6
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 5{
            return "100+"
        }else{
          return "\(String((row+1)*10+1))-\(String((row+2)*10))"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            if row == 5{
                numberOfCustomerField.text = "100+"
            }else{
                numberOfCustomerField.text = "\(String((row+1)*10+1))-\(String((row+2)*10))"
            }
    }
    
    @objc func dateChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        dateField.text = dateFormatter.string(from:sender.date)
    }
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }

}

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespacesAndNewlines).joined()
    }

}
