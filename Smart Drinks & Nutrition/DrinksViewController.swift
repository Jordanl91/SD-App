//
//  DrinksViewController.swift
//  Smart Drinks & Nutrition
//
//  Created by Phanidhar Mothukuri on 9/20/17.
//  Copyright © 2017 TechSoft,Inc. All rights reserved.
//

import UIKit

class DrinksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @objc let smoothiesCategories = ["Smart smoothies","Fruit smoothies"]
    @objc let coffeeCategories = ["HOT DRINKS", "ICED DRINKS", "BLENDED (FRAPPÉCCIANO)"]
    @objc var smoothiesDatasourceDictionary = [String:Any]()
    @objc var coffeeDatasourceDictionary = [String:Any]()
    @objc var drinksArrayOfDictionary = [[String:Any]]()
    @objc var smartSmoothiesArray = [String:Any]()
    @objc var juicesArray = [[String:Any]]()
    @objc var totalSmoothies = [[String:Any]]()
    @objc var totalCoffees = [[String:Any]]()
    var hotCoffees = [[String:Any]]()
    var icedCoffees = [[String:Any]]()
    var blendedCoffees = [[String:Any]]()
    @objc var idsArray = [Int]()
    
    @IBOutlet weak var menuSegmentedControl: UISegmentedControl!

    @IBOutlet weak var drinksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drinksTableView.estimatedRowHeight = 44
        drinksTableView.estimatedSectionFooterHeight = 120
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
            if let hot = coffees[coffeeCategories[0]] as? [[String:Any]]{
                for coffee in hot{
                    hotCoffees.append(coffee)
                }
            }
            if let iced = coffees[coffeeCategories[1]] as? [[String:Any]]{
                for coffee in iced{
                    icedCoffees.append(coffee)
                }
            }
            if let blended = coffees[coffeeCategories[2]] as? [[String:Any]]{
                for coffee in blended{
                    blendedCoffees.append(coffee)
                }
            }

        }
        print(coffeeDatasourceDictionary.self)
        // just for testing

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if menuSegmentedControl.selectedSegmentIndex == 0 {
            return 2
        }else{
            return coffeeCategories.count
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
            if indexPath.section == 0{
            if indexPath.row < 7{
                cell?.drinkTitle.textColor = UIColor.init(red: 6/255, green: 43/255, blue: 98/255, alpha: 1)
                cell?.trademark.textColor = UIColor.init(red: 6/255, green: 43/255, blue: 98/255, alpha: 1)
                cell?.trademark.isHidden = false
            }else{
                cell?.drinkTitle.textColor = UIColor.orange
                cell?.trademark.isHidden = true
            }
            if let drink = totalSmoothies[indexPath.row]["name"] as? String
            {
                cell?.drinkTitle.text = drink.uppercased()
                cell?.drinkDescription.text = totalSmoothies[indexPath.row]["description"] as? String
            }
            }else{
                return UITableViewCell()
            }
        }else{
            cell?.drinkTitle.textColor = UIColor.brown
            cell?.trademark.textColor = UIColor.brown
            if indexPath.section == 0 {
                cell?.drinkTitle.text = hotCoffees[indexPath.row]["name"] as? String
                cell?.drinkDescription.text = hotCoffees[indexPath.row]["description"] as? String
                if indexPath.row == 5 || indexPath.row == 6{
                    cell?.trademark.isHidden = false
                }else{
                    cell?.trademark.isHidden = true
                }
            }else if indexPath.section == 1{
                cell?.drinkTitle.text = icedCoffees[indexPath.row]["name"] as? String
                cell?.drinkDescription.text = icedCoffees[indexPath.row]["description"] as? String
                cell?.trademark.isHidden = true
            }else{
                cell?.drinkTitle.text = blendedCoffees[indexPath.row]["name"] as? String
                cell?.drinkDescription.text = blendedCoffees[indexPath.row]["description"] as? String
                cell?.trademark.isHidden = false
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if menuSegmentedControl.selectedSegmentIndex == 0{
            if section == 0{
            return totalSmoothies.count
            }
            return 0
        }else{
            if section == 0{
                return hotCoffees.count
            }else if section == 1{
                return icedCoffees.count
            }else{
                return blendedCoffees.count
            }
        }
    }
    @IBAction func segmentChanged(_ sender: Any) {
        DispatchQueue.main.async {
            self.drinksTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if menuSegmentedControl.selectedSegmentIndex == 0{
            if section == 1{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SMOOTHIE_FOOTER")
                return cell
            }else{
                return nil
            }
        }else{
            if section == 2{
                let cell = tableView.dequeueReusableCell(withIdentifier: "COFFEE_FOOTER")
                return cell
            }else{
                return nil
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if menuSegmentedControl.selectedSegmentIndex == 0 {
            if section == 1 {
            return UITableViewAutomaticDimension
            }else{
                return 0
            }
        }else{
            if section == 0 {
                return 0
            }else if section == 1{
                return 0
            }else{
                return UITableViewAutomaticDimension
            }
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
