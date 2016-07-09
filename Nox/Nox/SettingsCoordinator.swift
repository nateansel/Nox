//
//  SettingsCoordinator.swift
//  Nox
//
//  Created by Nathan Ansel on 6/30/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit

protocol SettingsDelegate {
  func dismissSettings()
}

class SettingsCoordinator: NSObject {
  let navigationController: UINavigationController = {
    $0.navigationBar.translucent = true
    $0.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
    $0.navigationBar.shadowImage = UIImage()
    $0.navigationBar.tintColor = UIColor.whiteColor()
    $0.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    return $0
  }(UINavigationController())
  var childViewControllers = [UIViewController]()
  var delegate: SettingsDelegate?
  
  func start() {
    let vc = SettingsViewController()
    vc.delegate = self
    navigationController.pushViewController(vc, animated: false)
  }
}

extension SettingsCoordinator: SettingsViewControllerDelegate {
  func timeModeToggled(sender: UISwitch) {
    NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: Strings.Settings.twelveHourTime)
  }
  
  func sunriseNotificationsToggled(sender: UISwitch) {
    NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: Strings.Settings.sunriseNotificationStatus)
  }
  
  func sunsetNotificationsToggled(sender: UISwitch) {
    NSUserDefaults.standardUserDefaults().setBool(sender.on, forKey: Strings.Settings.sunsetNotificationStatus)
  }
  
  func presentSunriseCustomization() {
    let vc = NotificationCustomizationViewController()
    vc.delegate = self
    vc.settingsString = Strings.Settings.sunriseNotificationSettings
    navigationController.pushViewController(vc, animated: true)
  }
  
  func presentSunsetCustomization() {
    let vc = NotificationCustomizationViewController()
    vc.delegate = self
    vc.settingsString = Strings.Settings.sunsetNotificationSettings
    navigationController.pushViewController(vc, animated: true)
  }
  
  func presentAbout() {
    let vc = AboutViewController()
    navigationController.pushViewController(vc, animated: true)
  }
  
  func presentCredits() {
    let vc = CreditsViewController()
    navigationController.pushViewController(vc, animated: true)
  }
  
  func doneButtonPressed(sender: UIBarButtonItem) {
    delegate?.dismissSettings()
  }
}

extension SettingsCoordinator: NotificationCustomizationViewControllerDelegate {
  func selected(indexPath indexPath: NSIndexPath, settingsString: String) {
    if var array = NSUserDefaults.standardUserDefaults().arrayForKey(settingsString) as? [Bool] {
      array[indexPath.item] = true
      NSUserDefaults.standardUserDefaults().setObject(array, forKey: settingsString)
    }
  }
  
  func deselected(indexPath indexPath: NSIndexPath, settingsString: String) {
    if var array = NSUserDefaults.standardUserDefaults().arrayForKey(settingsString) as? [Bool] {
      array[indexPath.item] = false
      NSUserDefaults.standardUserDefaults().setObject(array, forKey: settingsString)
    }
  }
}
