//
//  SettingsViewController.swift
//  Nox
//
//  Created by Nathan Ansel on 6/23/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit
import Static

@objc protocol SettingsViewControllerDelegate: class {
  func timeModeToggled(sender: UISwitch)
  func sunriseNotificationsToggled(sender: UISwitch)
  func sunsetNotificationsToggled(sender: UISwitch)
  func presentSunriseCustomization()
  func presentSunsetCustomization()
  func presentAbout()
  func presentCredits()
  func doneButtonPressed(sender: UIBarButtonItem)
}

class SettingsViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var delegate: SettingsViewControllerDelegate?
  private var dataSource = DataSource()
  
  private var timeSwitch: UISwitch = {
    $0.on = NSUserDefaults.standardUserDefaults().boolForKey(Strings.Settings.twelveHourTime)
    return $0
  }(UISwitch())
  
  private var sunriseSwitch: UISwitch = {
    $0.on = NSUserDefaults.standardUserDefaults().boolForKey(Strings.Settings.sunriseNotificationStatus)
    return $0
  }(UISwitch())
  
  private var sunsetSwitch: UISwitch = {
    $0.on = NSUserDefaults.standardUserDefaults().boolForKey(Strings.Settings.sunsetNotificationStatus)
    return $0
  }(UISwitch())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    timeSwitch.addTarget(delegate, action: #selector(SettingsViewControllerDelegate.timeModeToggled), forControlEvents: .ValueChanged)
    sunriseSwitch.addTarget(delegate, action: #selector(SettingsViewControllerDelegate.sunriseNotificationsToggled), forControlEvents: .ValueChanged)
    sunsetSwitch.addTarget(delegate, action: #selector(SettingsViewControllerDelegate.sunsetNotificationsToggled), forControlEvents: .ValueChanged)
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: delegate, action: #selector(SettingsViewControllerDelegate.doneButtonPressed))
    navigationItem.rightBarButtonItem = doneButton
    
    let gradientView = Theme.Night.gradientView
    view.insertSubview(gradientView, belowSubview: tableView)
    tableView.contentInset = UIEdgeInsetsMake(navigationController?.navigationBar.frame.maxY ?? 0, 0, 0, 0)
    
    navigationItem.title = "Settings"
    
    setupTableView()
  }
  
  private func setupTableView() {
    let row1 = Row(text: "24-Hour Time", accessory: .View(timeSwitch))
    let row2 = Row(text: "Sunrise Notifications", accessory: .View(sunriseSwitch))
    let row3 = Row(text: "Customize", accessory: .DisclosureIndicator, selection: { [unowned self] in
        self.delegate?.presentSunriseCustomization()
      }, cellClass: Value1Cell.self)
    let row4 = Row(text: "Sunset Notifications", accessory: .View(sunsetSwitch))
    let row5 = Row(text: "Customize", accessory: .DisclosureIndicator, selection: { [unowned self] in
        self.delegate?.presentSunsetCustomization()
      }, cellClass: Value1Cell.self)
    let row6 = Row(text: "About", accessory: .DisclosureIndicator, selection: { [unowned self] in
      self.delegate?.presentAbout()
    })
    let row7 = Row(text: "Credits", accessory: .DisclosureIndicator, selection: { [unowned self] in
      self.delegate?.presentCredits()
    })
    
    dataSource.sections = [
      Section(rows: [row1]),
      Section(rows: [row2,
                     row3]),
      Section(rows: [row4,
                     row5]),
      Section(rows: [row6,
                     row7])
    ]
    dataSource.tableView = tableView
  }
}
