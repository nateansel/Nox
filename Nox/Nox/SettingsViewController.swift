//
//  SettingsViewController.swift
//  Nox
//
//  Created by Nathan Ansel on 6/23/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit
import Static

class SettingsViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
  }
  
  private func setupTableView() {
    let dataSource = DataSource()
    var row = Row(text: "switch")
    row.accessory = .View(UISwitch())
    dataSource.sections = [
      Section(rows: [Row(text: "24-Hour Time", accessory: .View(UISwitch()))]),
      Section(rows: [Row(text: "Sunrise Notifications", accessory: .View(UISwitch())),
                     Row(text: "Customize", accessory: .DisclosureIndicator, cellClass: Value1Cell.self)]),
      Section(rows: [Row(text: "Sunset Notifications", accessory: .View(UISwitch())),
                     Row(text: "Customize", accessory: .DisclosureIndicator, cellClass: Value1Cell.self)]),
      Section(rows: [Row(text: "About", accessory: .DisclosureIndicator),
                     Row(text: "Credits", accessory: .DisclosureIndicator)])
    ]
    dataSource.tableView = tableView
  }
}
