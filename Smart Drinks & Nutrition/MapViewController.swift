//
//  MapViewController.swift
//  Smart Drinks & Nutrition
//
//  Created by Phanidhar Mothukuri on 9/10/17.
//  Copyright © 2017 TechSoft,Inc. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {
    @objc var latitude = 0.0
    @objc var longitude = 0.0
    @objc var truckLocation = [String:Any]()
    @objc var address = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(latitude)...... \(longitude)")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(" In did appear \(latitude)...... \(longitude)")
        let camera = GMSCameraPosition.camera(withLatitude: (truckLocation["lat"] as? Double)!, longitude: (truckLocation["lng"] as? Double)!, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        let markerImage = UIImage(named: "TruckMarker")!.withRenderingMode(.alwaysTemplate)
        let markerView = UIImageView(image: markerImage)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: (truckLocation["lat"] as? Double)!, longitude: (truckLocation["lng"] as? Double)!)
        marker.iconView = markerView
        marker.title = "Truck A"
        marker.snippet = address
        marker.map = mapView
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
