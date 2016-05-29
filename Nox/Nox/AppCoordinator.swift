//
//  AppCoordinator.swift
//  Nox
//
//  Created by Chase McCoy on 5/29/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit

class AppCoordinator {
  let navigationController: UINavigationController!
  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func start() {
    let vc = UIViewController()
    vc.view.backgroundColor = UIColor.orangeColor()
    navigationController.pushViewController(vc, animated: true)
  }
}

extension AppCoordinator {
  func setNotifications() {
    // TODO: Needs to be implemented
  }
}