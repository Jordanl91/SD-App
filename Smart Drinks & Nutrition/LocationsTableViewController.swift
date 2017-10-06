//
//  LocationsTableViewController.swift
//  Smart Drinks & Nutrition
//
//  Created by Phanidhar Mothukuri on 9/10/17.
//  Copyright © 2017 TechSoft,Inc. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker

class LocationsTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    @objc var placesClient: GMSPlacesClient!
    @objc let locationManager = CLLocationManager()
    @objc let truckLocations = [[String:Any]]()
    @objc var truckLocationToPass = [String:Any]()
//    var lats = [Double()]
//    var longs = [Double()]
//    var addresses = [String]()
//    var names = [String]()
//    var lat = Double()
//    var long = Double()
//    var address = String()


    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self as? CLLocationManagerDelegate
        placesClient = GMSPlacesClient.shared()
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    print(place.name)
                    print(place.coordinate)
                    print(place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n") as Any)
                }
            }
        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
        // mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
            placesClient = GMSPlacesClient.shared()
            placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
                if let error = error {
                    print("Pick Place error: \(error.localizedDescription)")
                    return
                }
                
                if let placeLikelihoodList = placeLikelihoodList {
                    let place = placeLikelihoodList.likelihoods.first?.place
                    if let place = place {
                        print(place.name)
                        print(place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n") as Any)
//                        self.getStarbucksNearMe(location: place.coordinate)
                        //populate list of starbucks location in a table view
                        
                        
                    }
                }
            })
        }
    }
    
//    func getStarbucksNearMe(location:CLLocationCoordinate2D){
//        let url = URL(string:"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(location.latitude),\(location.longitude)&radius=5000&keyword=starbucks&key=AIzaSyBIm7a1JO2BCRpiWrNJ7LpbwSrB6JTQos0")
//        let request = URLRequest(url:url!)
//        print(url!)
//        // let config = URLSession(configuration: .default)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
//            do{
//
//
//                guard let jsonVar = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any] else {
//                    return
//                }
//                print(jsonVar)
//                guard let resultArray = jsonVar["results"] as? [[String:Any]] else { return }
//                for item in resultArray{
//                    guard let geometry = item["geometry"] as? [String:Any] else {return}
//                    guard let name = item["name"] as? String else {return}
//                    guard let vicinity = item["vicinity"] as? String else {return}
//                    guard let location = geometry["location"] as? [String:Any] else{return}
//                    guard let latsLocal = location["lat"] as? Double else {return}
//                    guard let longLocal = location["lng"] as? Double else {return}
//                    //append coordinates
//                    self.lats.append(latsLocal)
//                    print(latsLocal,longLocal)
//                    self.longs.append(longLocal)
//                    //append address and name
//                    self.addresses.append(vicinity)
//                    self.names.append(name)
//
//                }
//                DispatchQueue.main.async {
//                    //reload table view
//                    self.tableView.reloadData()
//                }
//                print("Response:\(String(describing: response))")
//
//            }
//            catch let e as NSError{
//                print("Error: \(e.localizedDescription)")
//
//            }
//
//        })
//
//
//        task.resume()
//
//    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
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
        return SDNGlobal.sdnInstance.coordinates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "LOCATION_CELL")
        tableCell?.textLabel?.text = "Truck \(indexPath.row + 1)"
        tableCell?.detailTextLabel?.text = "\(SDNGlobal.sdnInstance.coordinates[indexPath.row]["lat"]!,SDNGlobal.sdnInstance.coordinates[indexPath.row]["lng"]! )"
        return tableCell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        lat = lats[indexPath.row+1]
//        long = longs[indexPath.row+1]
//        address = addresses[indexPath.row]
        truckLocationToPass = SDNGlobal.sdnInstance.coordinates[indexPath.row]
        performSegue(withIdentifier: "toMap", sender: self)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toMap"{
            let destination = segue.destination as? MapViewController
//            destination?.latitude = self.lat
            destination?.truckLocation = truckLocationToPass
//            destination?.longitude = self.long
//            destination?.address = self.address
        }
    }

}
