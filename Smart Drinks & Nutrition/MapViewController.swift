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
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate,GMSMapViewDelegate {
    
    @IBOutlet weak var truckStoreSegmentedControl: UISegmentedControl!
    @IBOutlet weak var mapView: GMSMapView!
    var latitude = 0.0
    var longitude = 0.0
   // @objc var placesClient: GMSPlacesClient!
    let locationManager = CLLocationManager()
    var truckLocations = [[String:Any]]()
    var truckLocation = [String:Any]()
    var address = String()
    var idsArray = [Int]()
    let storeLat = 29.9573183
    let storeLng = -95.6747608
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //houston city latitude and longitude
        let camera = GMSCameraPosition.camera(withLatitude: 29.7604, longitude: -95.3698, zoom: 12.0)
        self.mapView.camera = camera
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self as? CLLocationManagerDelegate
        getTrucksLocation()
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
        


//        print("\(latitude)...... \(longitude)")
        // Do any additional setup after loading the view.
    }
    
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
            print("comgooglemaps://?daddr=\(marker.position.latitude),\(marker.position.longitude)&directionsmode=driving")
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps://?daddr=\(marker.position.latitude),\(marker.position.longitude)&directionsmode=driving")!)
        } else {
            print("Can't use comgooglemaps://")
            if UIApplication.shared.canOpenURL(URL(string:"http://maps.apple.com")!){
                let regionDistance:CLLocationDistance = 10000
                let coordinates = CLLocationCoordinate2DMake(marker.position.latitude, marker.position.longitude)
                let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
                let options = [
                    MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
                    MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
                ]
                let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
                let mapItem = MKMapItem(placemark: placemark)
                print(marker.title!)
                mapItem.name = marker.title!
                mapItem.openInMaps(launchOptions: options)
            }
        }
    }

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if truckStoreSegmentedControl.selectedSegmentIndex == 1{
            let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 250, height: 100))
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 6
            
            let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
            lbl1.text = "Smart Drinks & Nutrition"
            view.addSubview(lbl1)
            
            let lbl2 = UILabel(frame: CGRect.init(x: lbl1.frame.origin.x, y: lbl1.frame.origin.y + lbl1.frame.size.height + 3, width: view.frame.size.width - 16, height: 60))
                lbl2.numberOfLines = 3
            lbl2.text = """
                12343 Barker Cypress,
                Ste. 250 Cypress,
                TX 77249
            """
            if #available(iOS 8.2, *) {
                lbl2.font = UIFont.systemFont(ofSize: 14, weight: .light)
            } else {
                // Fallback on earlier versions
            }
            view.addSubview(lbl2)
            return view
        }else{
            let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 200, height: 44))
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 6
            let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
            lbl1.text = "\(marker.title ?? "")"
            view.addSubview(lbl1)
            return view
        }
        
        }
    
    func getTrucksLocation(){
        SDNGlobal.sdnInstance.getDevices(completionHandler:{
            (success, error) -> Void in
            DispatchQueue.main.async{
                self.activityIndicator.startAnimating()
                self.activityIndicator.hidesWhenStopped = true
            }
            if error == nil {
                self.idsArray.removeAll()
                SDNGlobal.sdnInstance.coordinates.removeAll()
                print("after getting \(SDNGlobal.sdnInstance.devicesJson)")
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
                                        }else{
                                            if let success = SDNGlobal.sdnInstance.trackingJson["success"] as? Bool{
                                                if success == false {
                                                    //show alert
                                                    DispatchQueue.main.async {
                                                        self.activityIndicator.stopAnimating()
                                                        
                                                    }
                                                }
                                            }
                                            // device might be blocked
                                            
                                        }
                                    }
                                    DispatchQueue.main.async {
                                        self.showMap()
                                        
                                    }

                                    
                                }
                        }else{
                                // when ever there is an error
                                DispatchQueue.main.async {
                                    self.activityIndicator.stopAnimating()
                                    
                                }
                                
                            }
                        })
                        
                    }else{
                        //show alert that there are no trucks or no data returned. This might happen when there is no network connection or server issues.
                    }
                }
                
                
            }
        })
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

        //view = mapView
        mapView.clear()
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(SDNGlobal.sdnInstance.coordinates[0]["lat"] as! CLLocationDegrees, SDNGlobal.sdnInstance.coordinates[0]["lng"] as! CLLocationDegrees)
        var bounds: GMSCoordinateBounds = GMSCoordinateBounds(coordinate: myLocation, coordinate: myLocation)
        
        for marker in SDNGlobal.sdnInstance.coordinates {
            bounds = bounds.includingCoordinate(CLLocationCoordinate2DMake(marker["lat"] as! CLLocationDegrees, marker["lng"] as! CLLocationDegrees))
            mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 90.0))
        }
        
        for (index,location) in SDNGlobal.sdnInstance.coordinates.enumerated(){
//            let markerImage = UIImage(named: "TruckMarker")!.withRenderingMode(.alwaysTemplate)
//            let markerView = UIImageView(image: markerImage)
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: (location["lat"] as? Double)!, longitude: (location["lng"] as? Double)!)
            marker.icon = UIImage(named: "TruckMarker")
            marker.title = "Smart Drinks Truck \(index+1)"
            marker.snippet = address
            marker.map = mapView
        }
        DispatchQueue.main.async {
          self.activityIndicator.stopAnimating()
        }
        
        
    }
    
    func getPhysicalStoreLocation(){
        // setting the camera
        mapView.clear()
        let camera = GMSCameraPosition.camera(withLatitude: storeLat, longitude: storeLng, zoom: 12.0)
        self.mapView.camera = camera
        // draw the markers
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude:storeLat, longitude: storeLng)
        marker.icon = UIImage(named: "Store_Marker")
        marker.title = "Smart Drinks, 12343 Barker Cypress, Ste. 250 Cypress, TX 77249"
        marker.snippet = address
        marker.map = mapView
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
    @IBAction func didChangeSegment(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            //get trucks new location
            getTrucksLocation()
            
        }else{
            getPhysicalStoreLocation()
            //get physical stores location
            
        }
        
    }
    
}
