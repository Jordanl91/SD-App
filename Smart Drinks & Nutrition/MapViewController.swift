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
    var truckLabels = [String]()
    let storeLat = 29.957623
    let storeLng = -95.672420
    let defaults = UserDefaults.standard
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        //houston city latitude and longitude
        let camera = GMSCameraPosition.camera(withLatitude: 29.7604, longitude: -95.3698, zoom: 12.0)
        self.mapView.camera = camera
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        refreshButton.tintColor = .white
        loadMapDataForTrucks()
    }
    
    @IBAction func refreshTapped(_ sender: Any) {
        // refresh the truck location
        if truckStoreSegmentedControl.selectedSegmentIndex == 0{
            loadMapDataForTrucks()
        }
        
        
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
            let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 150, height: 44))
            view.backgroundColor = UIColor.white
            view.layer.cornerRadius = 6
            let lbl1 = UILabel(frame: CGRect.init(x: 8, y: 8, width: view.frame.size.width - 16, height: 15))
            lbl1.textAlignment = .center
            lbl1.text = "\(marker.title ?? "")"
            view.addSubview(lbl1)
            return view
        }
        
        }
    
    func getTrucksLocation(){
        SDNGlobal.sdnInstance.getDevices(completionHandler:{
            (success, error) -> Void in
            DispatchQueue.main.async{
                self.activityIndicator.hidesWhenStopped = true
                self.activityIndicator.startAnimating()
            }
            if error == nil {
                self.idsArray.removeAll()
                self.truckLabels.removeAll()
                SDNGlobal.sdnInstance.coordinates.removeAll()
                print("after getting \(SDNGlobal.sdnInstance.devicesJson)")
                if let list = SDNGlobal.sdnInstance.devicesJson["list"] as? [[String:Any]]{
                    for tracker in list{
                        if let ids = tracker["id"] as? Int {
                            self.idsArray.append(ids)
                        }
                        if let labels = tracker["label"] as? String{
                            self.truckLabels.append(labels)
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
                                    self.errorAlert(withError: (error?.localizedDescription)!)
                                    
                                }
                                
                            }
                        })
                        
                    }else{
                        //show alert that there are no trucks or no data returned. This might happen when there is no network connection or server issues.
                    }
                }
                
                
            }else{
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.errorAlert(withError: (error?.localizedDescription)!)
                }
            }
        })
    }
    
    
    @objc func loadMapDataForTrucks(){
        if defaults.value(forKey: "HASH_VALUE") != nil {
            print("There is an existing token")
            SDNGlobal.sdnInstance.urlHash = self.defaults.value(forKey: "HASH_VALUE") as! String
        SDNGlobal.sdnInstance.getDevices(completionHandler:
            {(success,error) -> Void in
                if error == nil{
                    if let valid = SDNGlobal.sdnInstance.devicesJson["success"] as? Bool{
                        if valid{
                            // The hash is good dont do anything
                            print("Token is good")
                            self.getTrucksLocation()

                        }else{
                            // go get the new hash
                            print("Getting Token")
                            SDNGlobal.sdnInstance.getHash(completionHandler:{
                                (success,error) -> Void in
                                if error == nil{
                                    if let hash = SDNGlobal.sdnInstance.hashJson["hash"] as? String{
                                        print("Saving hash \(hash)")
                                        self.defaults.setValue(hash, forKey: "HASH_VALUE")
                                        SDNGlobal.sdnInstance.urlHash = hash
                                        self.getTrucksLocation()

                                    }
                                }else{
                                    DispatchQueue.main.async {
                                        self.activityIndicator.stopAnimating()
                                        self.errorAlert(withError: (error?.localizedDescription)!)
                                    }
                                }
                            })
                        }
                    }
                }else{
                    //MARK: -Handle network issues
                    print("Localized Description: \(error?.localizedDescription,error?.code)")
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.activityIndicator.hidesWhenStopped = true
                        self.errorAlert(withError: (error?.localizedDescription)!)
                    }
                    
                }
            }
        )
        }else{
            print("There is no token getting one....")
            SDNGlobal.sdnInstance.getHash(completionHandler:{
                (success,error) -> Void in
                if error == nil{
                    if let hash = SDNGlobal.sdnInstance.hashJson["hash"] as? String{
                        print("Saving hash \(hash)")
                        SDNGlobal.sdnInstance.urlHash = hash
                        self.defaults.setValue(hash, forKey: "HASH_VALUE")
                        self.getTrucksLocation()
                        
                    }
                }else{
                    DispatchQueue.main.async {
                        self.errorAlert(withError: (error?.localizedDescription)!)
                    }
                    print(String(describing: error?.code), error.debugDescription)
                }
            })
        }
        
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
            locationManager.startUpdatingLocation()
            
            //5

            print("Location status is OK.")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        // 8
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        // if location allowed
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                print("Not determined. so request auth")
            case .restricted, .denied:
                print("throw alert")
                locationAlert(withAlert: "Please enable location services in settings")
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                locationManager.startUpdatingLocation()
            }
        } else {
            print("Location services are not enabled")
            return false
        }
        // else block all and prompt to enable the locations in the settings
        return true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
//          check if the truck falls in the blocked region
            //29.96757 , 29.97080  , -95.67190 , -95.66870
            if !((location["lat"] as! Double) > 29.96757 && (location["lat"] as! Double) < 29.97080 && (location["lng"] as! Double > -95.67190) && (location["lng"] as! Double) < -95.66870){
            marker.position = CLLocationCoordinate2D(latitude: (location["lat"] as? Double)!, longitude: (location["lng"] as? Double)!)
            marker.icon = UIImage(named: "TruckMarker")
            marker.title = truckLabels[index]
            marker.snippet = address
            marker.map = mapView
            }
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

    @IBAction func didChangeSegment(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            //get trucks new location
            loadMapDataForTrucks()
            refreshButton.isEnabled = true
            
        }else{
            refreshButton.isEnabled = false
            getPhysicalStoreLocation()
            //get physical stores location
            
        }
        
    }
    
    func errorAlert(withError description:String){
        let alert = UIAlertController(title: "Error", message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func locationAlert(withAlert description:String){
        let alert = UIAlertController(title: "Location disabled", message: description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Default action"), style: .`default`, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.openURL(settingsUrl)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
