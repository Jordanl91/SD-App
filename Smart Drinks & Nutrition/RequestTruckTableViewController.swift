//
//  RequestTruckTableViewController.swift
//  Smart Drinks & Nutrition
//
//  Created by Phanidhar Mothukuri on 10/11/17.
//  Copyright © 2017 TechSoft,Inc. All rights reserved.
//

import UIKit
import MessageUI
protocol RequestTruckDelegate : class {
    func didPressedRequestTruck(sender: NutritionTableViewCell)
    func showAlert()
    func dismissKeyboard()
    //func showDatePicker(sender:NutritionTableViewCell)
}


class RequestTruckTableViewController: UITableViewController {
    var customerCount = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.tableFooterView = UIView()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NUTRITION_CELL") as? NutritionTableViewCell
        // Configure the cell...
        cell?.delegate = self
        
        return cell!

    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Clicked")
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1000
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row+1)
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        customerCount = row+1
    }

}
extension RequestTruckTableViewController: RequestTruckDelegate, MFMessageComposeViewControllerDelegate{
    
    func didPressedRequestTruck(sender: NutritionTableViewCell) {
        if !MFMessageComposeViewController.canSendText() {
            print("SMS services are not available")
        }else{
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.recipients = ["phani@techsoftinc.net"]
            composeVC.body = "Name:\(sender.nameTextField.text!)\nPhone:\(sender.phoneNumber.text!)\nDate:\(sender.dateField.text!)\nCustomers:\(sender.numberOfCustomerField.text!)\nAddress:\(sender.addressTextField.text!)\nNotes:\(sender.notes.text!)"
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
        // Check the result or perform other tasks.
        
        // Dismiss the message compose view controller.
        controller.dismiss(animated: true, completion: nil)
        
    }
    
    func showAlert(){
        //This method called when the required fields are not satisfied.
        let alert = UIAlertController(title: "Missing fields", message: "Please enter all the mandatory fields", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
    func dismissKeyboard() {
        self.resignFirstResponder()
    }
//    func showDatePicker(sender:NutritionTableViewCell){
//        datePickerHeightConstraint.constant = 162
//        truckDatePicker.isOpaque = true
//        truckDatePicker.isHidden = false
//    }
//
//    func hideDatePicker(sender:NutritionTableViewCell){
//        datePickerHeightConstraint.constant = 0
//        truckDatePicker.isHidden = true
//    }
    

}


