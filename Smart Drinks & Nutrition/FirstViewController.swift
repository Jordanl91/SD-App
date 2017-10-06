//
//  FirstViewController.swift
//  Smart Drinks & Nutrition
//
//  Created by Phanidhar Mothukuri on 8/24/17.
//  Copyright © 2017 TechSoft,Inc. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @objc let drinksCategories = ["Smart smoothies","Fruit smoothies", "Boosters", "Additional Flavors"]
    @objc var datasourceDictionary = [String:Any]()
    @objc var drinksArrayOfDictionary = [[String:Any]]()
    @objc var drinksArray = [String]()
    @objc var smoothiesArray = [String:Any]()
    @objc var juicesArray = [[String:Any]]()
    
    @IBOutlet weak var drinksTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 100/255, green: 80/255, blue: 200/255, alpha: 1)
        //drinksTableView.backgroundColor = UIColor.init(red: 100/255, green: 80/255, blue: 200/255, alpha: 1)
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = false
        drinksTableView.tableFooterView = UIView()
        let pathStr = Bundle.main.path(forResource: "Drinks", ofType: "plist")
        let data :NSData? = NSData(contentsOfFile: pathStr!)
        datasourceDictionary = try! PropertyListSerialization.propertyList(from: data! as Data, options: [], format: nil) as! [String:Any]
        if let smoothies = datasourceDictionary["smoothies"] as? [String:Any]{
            smoothiesArray = smoothies
        }
        if let juices = datasourceDictionary["juices"] as? [[String:Any]]{
            juicesArray = juices
        }
        print(datasourceDictionary.self)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DRINKS_CELL")
        if indexPath.section == 0 {
            cell?.accessoryType = .disclosureIndicator
            cell?.textLabel?.text = drinksCategories[indexPath.row]
        }else{
            cell?.accessoryType = .none
            cell?.textLabel?.text = juicesArray[indexPath.row]["name"] as? String
        }
//        cell?.textLabel?.textColor = UIColor.white
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return drinksCategories.count
        }else{
            return 4
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Smoothies"
        }else{
            return "Juices"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get the detals screen data and perform segue.
        if indexPath.section == 0 {
        if indexPath.row < 2{
            drinksArrayOfDictionary = smoothiesArray[drinksCategories[indexPath.row]] as! [[String : Any]]
        }else{
            drinksArray = smoothiesArray[drinksCategories[indexPath.row]] as! [String]
        }
        performSegue(withIdentifier: "Drinks_Detail_Segue", sender: indexPath.row)
        }else{
            // do nothing
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DrinksDetailTableViewController{
            if let index = sender as? Int{
                if index < 2{
                    destination.drinksArrayOfDictionary = self.drinksArrayOfDictionary
                    destination.title = drinksCategories[index]
                }else{
                    destination.drinkNames = self.drinksArray
                    destination.title = drinksCategories[index]
                }
            }

        }
        
    }
    
}

