//
//  LocationManager.swift
//  DouYin
//
//  Created by Niu Changming on 8/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate{
    
    var currentLocation: CLLocation!
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        locationManager.startMonitoringSignificantLocationChanges();
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()

    static let share : LocationManager = {
        let manager = LocationManager()
        return manager
    }()
    
    func startMonitor() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    func getAdress(completion: @escaping (_ address: [String: Any]?, _ error: Error?) -> ()) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(self.currentLocation) { placemarks, error in
            if let e = error {
                completion(nil, e)
            } else {
                if let placeMark = placemarks?[0] {
                    guard let address = placeMark.addressDictionary as? [String: Any] else {
                        return
                    }
                    completion(address, nil)
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLoc = locations.last {
            currentLocation = lastLoc
        } else {
            print("No coordinates")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func stopMonitor() {
        locationManager.stopUpdatingLocation()
    }

}
