//
//  MainViewController.swift
//  Nox
//
//  Created by Chase McCoy on 5/29/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit
import KosherCocoa

protocol MainViewControllerDelegate {
  func getCurrentSunEvent()
  func settingsButtonTapped()
}

class MainViewController: UIViewController {
  @IBOutlet var timeLabel: UILabel!
  
  var delegate: MainViewControllerDelegate?
  
  var currentSunEvent: SunEvent? {
    didSet {
      switch currentSunEvent! {
      case .Sunrise(let date):
        timeLabel.text = "Sunrise"
      case .Sunset(let date):
        timeLabel.text = "Sunset"
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBarHidden = true
    view.insertSubview(Theme.Day.gradientView, atIndex: 0)
    delegate?.getCurrentSunEvent()
  }
}