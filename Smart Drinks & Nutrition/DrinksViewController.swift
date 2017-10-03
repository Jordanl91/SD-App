//
//  DrinksViewController.swift
//  Smart Drinks & Nutrition
//
//  Created by Phanidhar Mothukuri on 9/20/17.
//  Copyright © 2017 TechSoft,Inc. All rights reserved.
//

import UIKit

class DrinksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let smoothiesCategories = ["Smart smoothies","Fruit smoothies"]
    let coffeeCategories = ["BLENDED (FRAPPECCIANO)","HOT DRINKS", "ICED DRINKS"]
    var smoothiesDatasourceDictionary = [String:Any]()
    var coffeeDatasourceDictionary = [String:Any]()
    var drinksArrayOfDictionary = [[String:Any]]()
    var smartSmoothiesArray = [String:Any]()
    var juicesArray = [[String:Any]]()
    var totalSmoothies = [[String:Any]]()
    var totalCoffees = [[String:Any]]()
    var idsArray = [Int]()
    
    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!

    @IBOutlet weak var drinksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //smoothie processing
//        menuSegmentedControl.addTarget(self, action: #selector(didChangeSegment), for: .touchUpInside)
        let smoothiesPathStr = Bundle.main.path(forResource: "smoothies", ofType: "plist")
        let data :NSData? = NSData(contentsOfFile: smoothiesPathStr!)
        smoothiesDatasourceDictionary = try! PropertyListSerialization.propertyList(from: data! as Data, options: [], format: nil) as! [String:Any]
        if let smoothies = smoothiesDatasourceDictionary["smoothies"] as? [String:Any]{
            if let smartSmoothies = smoothies[smoothiesCategories[0]] as? [[String:Any]]{
                for smoothie in smartSmoothies{
                    totalSmoothies.append(smoothie)
                }
            }
            if let fruitSmoothies = smoothies[smoothiesCategories[1]] as? [[String:Any]]{
                for smoothie in fruitSmoothies{
                    totalSmoothies.append(smoothie)
                }
            }
            
        }
        
        // coffee processing
        
        let coffeePathStr = Bundle.main.path(forResource: "coffee", ofType: "plist")
        let coffeeData :NSData? = NSData(contentsOfFile: coffeePathStr!)
        coffeeDatasourceDictionary = try! PropertyListSerialization.propertyList(from: coffeeData! as Data, options: [], format: nil) as! [String:Any]
        if let coffees = coffeeDatasourceDictionary["coffee"] as? [String:Any]{
            if let blended = coffees[coffeeCategories[0]] as? [[String:Any]]{
                for coffee in blended{
                    totalCoffees.append(coffee)
                }
            }
            if let hot = coffees[coffeeCategories[1]] as? [[String:Any]]{
                for coffee in hot{
                    totalCoffees.append(coffee)
                }
            }
            if let iced = coffees[coffeeCategories[2]] as? [[String:Any]]{
                for coffee in iced{
                    totalCoffees.append(coffee)
                }
            }
            
        }
        print(coffeeDatasourceDictionary.self)
        // just for testing
        SDNGlobal.sdnInstance.getDevices(completionHandler:{
            (success, error) -> Void in
            if error == nil {
                print(SDNGlobal.sdnInstance.devicesJson)
                if let list = SDNGlobal.sdnInstance.devicesJson["list"] as? [[String:Any]]{
                    for tracker in list{
                        if let ids = tracker["id"] as? Int {
                           self.idsArray.append(ids)
                        }
                    }
                    // now you got the ids make API calls for each id to get their locations
                    if self.idsArray.count > 0 {
                        SDNGlobal.sdnInstance.coordinates.removeAll()
                        for id in self.idsArray {
                            
                            // loop for each location
                        SDNGlobal.sdnInstance.getLocation(withTracker: id , completionHandler: {(success,error)  -> Void in
                            if error == nil{
                                
                                // clearing all the existing array values... make sure you get the same count for both the latitude and longitudes
                        

                                print(SDNGlobal.sdnInstance.trackingJson)
                                if let gpsTracker = SDNGlobal.sdnInstance.trackingJson["states"] as? [String:Any] {
                                    if let deviceId = gpsTracker["\(id)"] as? [String:Any] {
                                       if let gps = deviceId["gps"] as? [String:Any]{
                                           if let location = gps["location"] as? [String:Any]{
                                                SDNGlobal.sdnInstance.coordinates.append(location)
                                                print(SDNGlobal.sdnInstance.coordinates)
                                            }
                                        }
                                    }
                                }
                            }
                        })
                        }
                    }else{
                        //show alert that there are no trucks or no data returned. This might happen when there is no network connection or server issues.
                    }
                }
                
                
            }
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if menuSegmentedControl.selectedSegmentIndex == 0 {
            return 1
        }else{
            return 3
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if menuSegmentedControl.selectedSegmentIndex == 0{
            return nil
        }else{
            return coffeeCategories[section]
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DRINKS_CELL") as? DrinksTableViewCell
        if menuSegmentedControl.selectedSegmentIndex == 0 {
            cell?.drinkTitle.text = totalSmoothies[indexPath.row]["name"] as? String
            cell?.drinkDescription.text = totalSmoothies[indexPath.row]["description"] as? String
        }else{
            if indexPath.section == 0 {
                if indexPath.row < 4 {
                cell?.drinkTitle.text = totalCoffees[indexPath.row]["name"] as? String
                cell?.drinkDescription.text = totalCoffees[indexPath.row]["description"] as? String
                }
            }else if indexPath.section == 1{
                if indexPath.row < 13 {
                cell?.drinkTitle.text = totalCoffees[indexPath.row]["name"] as? String
                cell?.drinkDescription.text = totalCoffees[indexPath.row]["description"] as? String
                }
            }else{
                if indexPath.row < 16 {
                    cell?.drinkTitle.text = totalCoffees[indexPath.row]["name"] as? String
                    cell?.drinkDescription.text = totalCoffees[indexPath.row]["description"] as? String
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menuSegmentedControl.selectedSegmentIndex == 0{
            return totalSmoothies.count
        }else{
            if section == 0{
                return 4
            }else if section == 1{
                return 9
            }else{
                return 3
            }
        }
    }
    @IBAction func segmentChanged(_ sender: Any) {
        DispatchQueue.main.async {
            self.drinksTableView.reloadData()
        }
    }
    
//    func didChangeSegment(){
//        DispatchQueue.main.async {
//            self.drinksTableView.reloadData()
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
