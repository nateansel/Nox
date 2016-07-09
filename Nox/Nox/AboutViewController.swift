//
//  AboutViewController.swift
//  Nox
//
//  Created by Nathan Ansel on 7/9/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let gradientView = Theme.Night.gradientView
    view.addSubview(gradientView)
  }
}
