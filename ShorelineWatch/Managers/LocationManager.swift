//
//  LocationManager.swift
//  ShorelineWatch
//
//  Created by Juan Marino on 7/1/24.
//

import Foundation
import CoreLocation //apple to get user current location

//the protocols help us manage anything related to location without getting errors
class LocationManager: NSObject,ObservableObject,CLLocationManagerDelegate{
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D? //optional if we cant get loation
    @Published var isLoading = false
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation(){
        isLoading = true
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        isLoading = false
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Error getting location",error)
        isLoading = false
    }
}
