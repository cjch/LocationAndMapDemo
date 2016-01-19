//
//  ViewController.swift
//  LocationAndMapDemo
//
//  Created by jiechen on 16/1/19.
//  Copyright © 2016年 jiechen. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var horAccLabel: UILabel!
    @IBOutlet weak var altitudeLabel: UILabel!
    @IBOutlet weak var verAccLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var locationManager: CLLocationManager?
    var startPoint: CLLocation?
    var distanceFromStart: CLLocationDistance?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager?.delegate = self;
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        
//        let status = CLLocationManager.authorizationStatus()
        if UIDevice.currentDevice().systemVersion > "8" {
            locationManager?.requestAlwaysAuthorization()
        }
        
        locationManager?.startUpdatingLocation()
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last
        
        latitudeLabel.text = String(format: "%g\u{00B0}", (newLocation?.coordinate.latitude)!)
        longitudeLabel.text = String(format: "%g\u{00B0}", (newLocation?.coordinate.longitude)!)
        horAccLabel.text = String(format: "%gm", (newLocation?.horizontalAccuracy)!)
        
        altitudeLabel.text = String(format: "%gm", (newLocation?.altitude)!)
        verAccLabel.text = String(format: "%gm", (newLocation?.verticalAccuracy)!)
        
        if newLocation?.horizontalAccuracy < 0 || newLocation?.verticalAccuracy < 0 {
            return;
        }
        
        if newLocation?.horizontalAccuracy > 100 || newLocation?.verticalAccuracy > 50 {
            return;
        }
        
        if startPoint == nil {
            startPoint = newLocation;
            distanceFromStart = 0;
        } else {
            self.distanceFromStart = newLocation?.distanceFromLocation(startPoint!)
        }
        print(distanceFromStart)
        distanceLabel.text = String(format: "%gm", distanceFromStart!);
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
        let message = error.code == CLError.Denied.rawValue ? "Access Denied" : error.description
        let alert = UIAlertView(title: "error getting location", message: message, delegate: nil, cancelButtonTitle: "ok")
        alert.show()
    }
}

