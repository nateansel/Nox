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
    let settingsCoordinator = SettingsCoordinator()
    settingsCoordinator.delegate = self
    settingsCoordinator.start()
    navigationController.presentViewController(settingsCoordinator.navigationController, animated: true, completion: nil)
  }
}

extension AppCoordinator: SettingsDelegate {
  func dismissSettings() {
    navigationController.dismissViewControllerAnimated(true, completion: nil)
  }
}

extension AppCoordinator {
  func setNotifications() {
    let minuteOffsets = [-180,
                         -165,
                         -150,
                         -135,
                         -120,
                         -105,
                         -90,
                         -75,
                         -60,
                         -45,
                         -30,
                         -15,
                         0,
                         15,
                         30,
                         45,
                         60,
                         75,
                         90,
                         105,
                         120,
                         135,
                         150,
                         165,
                         180]
    // TODO: Needs to be implemented
    UIApplication.sharedApplication().cancelAllLocalNotifications()
    if NSUserDefaults.standardUserDefaults().boolForKey(Strings.Settings.sunsetNotificationStatus) {
      if let array = NSUserDefaults.standardUserDefaults().arrayForKey(Strings.Settings.sunsetNotificationSettings) as? [Bool] {
        for (i, setting) in array.enumerate() {
          if setting {
            let notification = UILocalNotification()
            notification.alertBody = "\(abs(minuteOffsets[i])) minutes until sunset."
            notification.fireDate = sunEventService.getNextSunEvent().date.dateByAddingTimeInterval(NSTimeInterval(minuteOffsets[i]))
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
          }
        }
      }
    }
  }
}