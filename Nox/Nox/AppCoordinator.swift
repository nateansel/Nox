//
//  AppCoordinator.swift
//  Nox
//
//  Created by Chase McCoy on 5/29/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit
import CoreLocation

class AppCoordinator: NSObject, ManagesLocation {
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

extension AppCoordinator: CLLocationManagerDelegate {
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    print(locations.last?.coordinate.latitude)
    sunEventService.location = locations.last!
    mainViewController?.currentSunEvent = sunEventService.getNextSunEvent()
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
    let sunriseStatus = NSUserDefaults.standardUserDefaults().boolForKey(Strings.Settings.sunriseNotificationStatus)
    let sunsetStatus  = NSUserDefaults.standardUserDefaults().boolForKey(Strings.Settings.sunsetNotificationStatus)
    let sunriseArray  = NSUserDefaults.standardUserDefaults().arrayForKey(Strings.Settings.sunriseNotificationSettings) as? [Bool]
    let sunsetArray   = NSUserDefaults.standardUserDefaults().arrayForKey(Strings.Settings.sunsetNotificationSettings) as? [Bool]
    
    var numberOfNotifications = 0
    if sunriseStatus, let array = sunriseArray {
      for notification in array {
        if notification {
          numberOfNotifications += 1
        }
      }
    }
    if sunsetStatus, let array = sunsetArray {
      for notification in array {
        if notification {
          numberOfNotifications += 1
        }
      }
    }
    
    let sunEvents = 60 / numberOfNotifications
    let sunrises  = sunEventService.get(numberOfSunrises: sunEvents)
    let sunsets   = sunEventService.get(numberOfSunsets: sunEvents)
    
    UIApplication.sharedApplication().cancelAllLocalNotifications()
    if sunriseStatus, let array = sunriseArray {
      for (i, setting) in array.enumerate() {
        if setting {
          for sunrise in sunrises {
            let notification = UILocalNotification()
            notification.alertBody = "\(Strings.timeString(fromMinutes: abs(minuteOffsets[i]))) until sunrise."
            if minuteOffsets[i] == 0 {
              notification.alertBody = "The sun is rising!"
            }
            notification.fireDate = sunrise.date.dateByAddingTimeInterval(NSTimeInterval(minuteOffsets[i] * 60))
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
          }
        }
      }
    }
    if sunsetStatus, let array = sunsetArray {
      for (i, setting) in array.enumerate() {
        if setting {
          for sunset in sunsets {
            let notification = UILocalNotification()
            notification.alertBody = "\(Strings.timeString(fromMinutes: abs(minuteOffsets[i]))) until sunset."
            if minuteOffsets[i] == 0 {
              notification.alertBody = "The sun is setting!"
            }
            notification.fireDate = sunset.date.dateByAddingTimeInterval(NSTimeInterval(minuteOffsets[i] * 60))
            notification.soundName = UILocalNotificationDefaultSoundName
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
          }
        }
      }
    }
    
    if sunsetStatus || sunriseStatus {
      let notification = UILocalNotification()
      notification.alertBody = "Please open the app to refresh the data and continue receiving notifications."
      notification.fireDate = UIApplication.sharedApplication().scheduledLocalNotifications?.sort({ (first, second) -> Bool in
        return first.fireDate?.compare(second.fireDate!) == .OrderedAscending
      }).last?.fireDate?.dateByAddingTimeInterval(3600)
      notification.soundName = UILocalNotificationDefaultSoundName
      UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
  }
}