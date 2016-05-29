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
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    super.init()
  }
  
  func start() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    checkLocationPersmissions()
    
    let mainViewController = MainViewController()
    navigationController.pushViewController(mainViewController, animated: true)
  }
}

extension AppCoordinator: MainViewControllerDelegate {
  func getCurrentSunEvent() {
    if CLLocationManager.locationServicesEnabled() {
      locationManager.requestLocation()
    }
    
    if let mainViewController = mainViewController {
      mainViewController.currentSunEvent = SunEvent.Sunrise(NSDate())
    }
  }
  
  func settingsButtonTapped() {
    //
  }
}

extension AppCoordinator {
  func setNotifications() {
    // TODO: Needs to be implemented
  }
}