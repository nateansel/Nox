//
//  Location Manager.swift
//  Nox
//
//  Created by Chase McCoy on 5/29/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit
import CoreLocation

protocol ManagesLocation {
  var locationManager: CLLocationManager { get }
}
extension ManagesLocation {
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