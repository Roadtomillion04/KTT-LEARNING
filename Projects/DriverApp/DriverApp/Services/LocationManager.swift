//
//  LocationManager.swift
//  DriverApp
//
//  Created by Nirmal kumar on 01/09/25.
//

import Foundation
import CoreLocation


final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    let manager = CLLocationManager()
    @Published var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    
    func requestLocation() {
        
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
        
    }
    
    func startTracking() {
        manager.startUpdatingLocation()
    }
    
    func stopTracking() {
        manager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
           location = locations.first?.coordinate
       }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
           print("Location error: \(error.localizedDescription)")
       }
}
