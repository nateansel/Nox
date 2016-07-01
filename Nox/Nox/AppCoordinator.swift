//
//  AppCoordinator.swift
//  Nox
//
//  Created by Chase McCoy on 5/29/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit
import CoreLocation

class AppCoordinator: NSObject {
  let navigationController: UINavigationController!
  var mainViewController: MainViewController?
  
  let locationManager = CLLocationManager()
  var sunEventService = SunEventService()
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    super.init()
  }
  
  func start() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    locationManager.distanceFilter = 1000
    checkLocationPersmissions()
    
    mainViewController = MainViewController()
    mainViewController?.delegate = self
    navigationController.pushViewController(mainViewController!, animated: true)
  }
}

extension AppCoordinator: MainViewControllerDelegate {
  func getCurrentSunEvent() {
    if CLLocationManager.locationServicesEnabled() {
      locationManager.startUpdatingLocation()
    }
  }
  
  func settingsButtonTapped() {
    let settingsViewController = SettingsViewController()
    navigationController.presentViewController(settingsViewController, animated: true, completion: nil)
  }
}

extension AppCoordinator {
  func setNotifications() {
    // TODO: Needs to be implemented
  }
}