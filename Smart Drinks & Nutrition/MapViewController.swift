//
//  MapViewController.swift
//  Smart Drinks & Nutrition
//
//  Created by Phanidhar Mothukuri on 9/10/17.
//  Copyright © 2017 TechSoft,Inc. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

class MapViewController: UIViewController, CLLocationManagerDelegate {
    var latitude = 0.0
    var longitude = 0.0
   // @objc var placesClient: GMSPlacesClient!
    let locationManager = CLLocationManager()
    var truckLocations = [[String:Any]]()
    var truckLocation = [String:Any]()
    var address = String()
    var idsArray = [Int]()
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self as? CLLocationManagerDelegate
//        placesClient = GMSPlacesClient.shared()
//        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
//            if let error = error {
//                print("Pick Place error: \(error.localizedDescription)")
//                return
//            }
//
//            if let placeLikelihoodList = placeLikelihoodList {
//                let place = placeLikelihoodList.likelihoods.first?.place
//                if let place = place {
//                    print(place.name)
//                    print(place.coordinate)
//                    print(place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n") as Any)
//                }
//            }
//        })
        
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
                        var commaSeparatedIds = ""
                        for id in self.idsArray {
                            if commaSeparatedIds == ""{
                                commaSeparatedIds = "\(id)"
                            }else{
                                commaSeparatedIds = "\(commaSeparatedIds),\(id)"
                            }
                        }
                        
                        // loop for each location
                        SDNGlobal.sdnInstance.getLocation(withTrackers: commaSeparatedIds, completionHandler: {(success,error)  -> Void in
                            if error == nil{
                                
                                // clearing all the existing array values... make sure you get the same count for both the latitude and longitudes
                                
                                
                                print(SDNGlobal.sdnInstance.trackingJson)
                                if let gpsTracker = SDNGlobal.sdnInstance.trackingJson["states"] as? [String:Any] {
                                    for id in self.idsArray{
                                        if let deviceId = gpsTracker["\(id)"] as? [String:Any] {
                                            if let gps = deviceId["gps"] as? [String:Any]{
                                                if let location = gps["location"] as? [String:Any]{
                                                    SDNGlobal.sdnInstance.coordinates.append(location)
                                                    print(SDNGlobal.sdnInstance.coordinates)
                                                }
                                            }
                                        }
                                    }
                                    DispatchQueue.main.async {
                                        self.showMap()
                                        self.activityIndicator.stopAnimating()
                                    }
                                    
                                }
                            }
                        })
                        
                    }else{
                        //show alert that there are no trucks or no data returned. This might happen when there is no network connection or server issues.
                    }
                }
                
                
            }
        })

//        print("\(latitude)...... \(longitude)")
        // Do any additional setup after loading the view.
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
//            placesClient = GMSPlacesClient.shared()
//            placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
//                if let error = error {
//                    print("Pick Place error: \(error.localizedDescription)")
//                    return
//                }
//
//                if let placeLikelihoodList = placeLikelihoodList {
//                    let place = placeLikelihoodList.likelihoods.first?.place
//                    if let place = place {
//                        print(place.name)
//                        print(place.formattedAddress?.components(separatedBy: ", ").joined(separator: "\n") as Any)
//                        //                        self.getStarbucksNearMe(location: place.coordinate)
//                        //populate list of starbucks location in a table view
//
//
//                    }
//                }
//            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        //print(" In did appear \(latitude)...... \(longitude)")
//        let camera = GMSCameraPosition.camera(withLatitude: (SDNGlobal.sdnInstance.coordinates[0]["lat"] as? Double)!, longitude: (SDNGlobal.sdnInstance.coordinates[0]["lng"] as? Double)!, zoom: 12.0)
//        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
//        view = mapView
//        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(SDNGlobal.sdnInstance.coordinates[0]["lat"] as! CLLocationDegrees, SDNGlobal.sdnInstance.coordinates[0]["lng"] as! CLLocationDegrees)
//        var bounds: GMSCoordinateBounds = GMSCoordinateBounds(coordinate: myLocation, coordinate: myLocation)
//
//        for marker in SDNGlobal.sdnInstance.coordinates {
//            bounds = bounds.includingCoordinate(CLLocationCoordinate2DMake(marker["lat"] as! CLLocationDegrees, marker["lng"] as! CLLocationDegrees))
//            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
//        }
//
//        for location in SDNGlobal.sdnInstance.coordinates{
//        let markerImage = UIImage(named: "TruckMarker")!.withRenderingMode(.alwaysTemplate)
//        let markerView = UIImageView(image: markerImage)
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: (location["lat"] as? Double)!, longitude: (location["lng"] as? Double)!)
//        marker.iconView = markerView
//        marker.title = "Truck location \(location["lat"]!),\(location["lng"]!)"
//        marker.snippet = address
//        marker.map = mapView
//        }
    }
    
    func showMap(){
        
        let camera = GMSCameraPosition.camera(withLatitude: (SDNGlobal.sdnInstance.coordinates[0]["lat"] as? Double)!, longitude: (SDNGlobal.sdnInstance.coordinates[0]["lng"] as? Double)!, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(SDNGlobal.sdnInstance.coordinates[0]["lat"] as! CLLocationDegrees, SDNGlobal.sdnInstance.coordinates[0]["lng"] as! CLLocationDegrees)
        var bounds: GMSCoordinateBounds = GMSCoordinateBounds(coordinate: myLocation, coordinate: myLocation)
        
        for marker in SDNGlobal.sdnInstance.coordinates {
            bounds = bounds.includingCoordinate(CLLocationCoordinate2DMake(marker["lat"] as! CLLocationDegrees, marker["lng"] as! CLLocationDegrees))
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 50.0))
        }
        
        for (index,location) in SDNGlobal.sdnInstance.coordinates.enumerated(){
            let markerImage = UIImage(named: "TruckMarker")!.withRenderingMode(.alwaysTemplate)
            let markerView = UIImageView(image: markerImage)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: (location["lat"] as? Double)!, longitude: (location["lng"] as? Double)!)
            marker.iconView = markerView
            marker.title = "Smart Drinks Truck \(index+1)"
            marker.snippet = address
            marker.map = mapView
        }
        
        
    }
 
//    func focusMapToShowAllMarkers() {
//        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(SDNGlobal.sdnInstance.coordinates[0]["lat"] as! CLLocationDegrees, SDNGlobal.sdnInstance.coordinates[0]["lng"] as! CLLocationDegrees)
//        var bounds: GMSCoordinateBounds = GMSCoordinateBounds(coordinate: myLocation, coordinate: myLocation)
//
//        for marker in SDNGlobal.sdnInstance.coordinates {
//            bounds = bounds.includingCoordinate(CLLocationCoordinate2DMake(marker["lat"] as! CLLocationDegrees, marker["lng"] as! CLLocationDegrees))
//            self.mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 15.0))
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
