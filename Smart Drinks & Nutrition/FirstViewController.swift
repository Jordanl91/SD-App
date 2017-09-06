//
//  FirstViewController.swift
//  Smart Drinks & Nutrition
//
//  Created by Phanidhar Mothukuri on 8/24/17.
//  Copyright © 2017 TechSoft,Inc. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let drinksCategories = ["Smart smoothies","Fruit smoothies", "Boosters", "Additional Flavors"]
    var datasourceDictionary = [String:Any]()
    var drinksArrayOfDictionary = [[String:Any]]()
    var drinksArray = [String]()
    @IBOutlet weak var drinksTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.init(red: 255/255, green: 70/255, blue: 50/255, alpha: 1)
        drinksTableView.backgroundColor = UIColor.init(red: 255/255, green: 70/255, blue: 50/255, alpha: 1)
        //self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController?.navigationBar.isTranslucent = false
        drinksTableView.tableFooterView = UIView()
        let pathStr = Bundle.main.path(forResource: "Drinks", ofType: "plist")
        let data :NSData? = NSData(contentsOfFile: pathStr!)
        datasourceDictionary = try! PropertyListSerialization.propertyList(from: data! as Data, options: [], format: nil) as! [String:Any]
        print(datasourceDictionary.self)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DRINKS_CELL")
        cell?.textLabel?.text = drinksCategories[indexPath.row]
        cell?.textLabel?.textColor = UIColor.white
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drinksCategories.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get the detals screen data and perform segue.
        if indexPath.row < 2{
            drinksArrayOfDictionary = datasourceDictionary[drinksCategories[indexPath.row]] as! [[String : Any]]
        }else{
            drinksArray = datasourceDictionary[drinksCategories[indexPath.row]] as! [String]
        }
        performSegue(withIdentifier: "Drinks_Detail_Segue", sender: indexPath.row)
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

