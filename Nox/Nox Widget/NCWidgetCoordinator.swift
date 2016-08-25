//
//  NCWidgetCoordinator.swift
//  Nox
//
//  Created by Nathan Ansel on 7/31/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit
import CoreLocation

class NCWidgetCoordinator: NSObject, ManagesLocation {
  var todayViewController: TodayViewController?
  
  let locationManager = CLLocationManager()
  var sunEventService = SunEventService()
  
  func start() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    locationManager.distanceFilter = 1000
    checkLocationPersmissions()
    
    todayViewController?.delegate = self
  }
}

extension NCWidgetCoordinator: TodayViewControllerDelegate {
  func getNextSunEvent() {
    if CLLocationManager.locationServicesEnabled() {
      locationManager.startUpdatingLocation()
    }
  }
}

extension NCWidgetCoordinator: CLLocationManagerDelegate {
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print(locations.last?.coordinate.latitude)
    sunEventService.location = locations.last!
    todayViewController?.sunEvent = sunEventService.getNextSunEvent()
  }
  
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    print("Error getting location")
  }
  
  func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
    if status == .AuthorizedAlways {
//      locationManager.requestLocation()
    }
  }
}
