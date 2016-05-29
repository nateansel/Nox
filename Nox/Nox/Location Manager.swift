//
//  Location Manager.swift
//  Nox
//
//  Created by Chase McCoy on 5/29/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit
import CoreLocation

extension AppCoordinator {
  func checkLocationPersmissions() {
    switch CLLocationManager.authorizationStatus() {
    case .NotDetermined:
      locationManager.requestAlwaysAuthorization()
    case .Restricted, .Denied:
      print("Location denied")
    default:
      break
    }
  }
}


extension AppCoordinator: CLLocationManagerDelegate {
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print(locations.first?.coordinate.latitude)
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    //
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedAlways {
      locationManager.requestLocation()
    }
  }
}