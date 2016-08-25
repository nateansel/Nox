//
//  MainViewController.swift
//  Nox
//
//  Created by Chase McCoy on 5/29/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit
//import KosherCocoa

protocol MainViewControllerDelegate {
  func getCurrentSunEvent()
  func settingsButtonTapped()
}

class MainViewController: UIViewController {
  @IBOutlet var sunEventDescriptionLabel: UILabel!
  @IBOutlet var timeLabel: UILabel!
  @IBOutlet var countdownLabel: UILabel!
  
  @IBOutlet var previousSunEventView: PreviousSunEventView!
  @IBOutlet var previousSunEventViewLeadingConstraint: NSLayoutConstraint!
  
  @IBOutlet var nextSunEventView: NextSunEventView!
  @IBOutlet var nextSunEventViewTrailingConstraint: NSLayoutConstraint!
  
  let dayGradientView = Theme.Day.gradientView
  let nightGradientView = Theme.Night.gradientView
  
  let dateFormatter: NSDateFormatter = {
    $0.dateFormat = "h:mm a"
    return $0
  }(NSDateFormatter())
  
  var delegate: MainViewControllerDelegate?
  
  var currentSunEvent: SunEvent? {
    didSet {
      switch currentSunEvent! {
      case .Sunrise:
        setSunriseLabels()
      case .Sunset:
        setSunsetLabels()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBarHidden = true
    view.insertSubview(dayGradientView, atIndex: 0)
    view.insertSubview(nightGradientView, atIndex: 0)
    delegate?.getCurrentSunEvent()
    
    previousSunEventView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(previousSunEventViewTapped)))
    nextSunEventView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextSunEventViewTapped)))
    
    toggleNextSunEventView()
    togglePreviousSunEventView()
    togglePreviousSunEventView()
  }
  
  private func setSunriseLabels() {
    sunEventDescriptionLabel.text = Strings.sunriseDescription
    let date = currentSunEvent?.date
    timeLabel.text = dateFormatter.stringFromDate(date!)
    countdownLabel.text = Strings.countdownText(forSunEvent: currentSunEvent!)
    setNightTheme()
  }
  
  private func setSunsetLabels() {
    sunEventDescriptionLabel.text = Strings.sunsetDescription
    let date = currentSunEvent?.date
    timeLabel.text = dateFormatter.stringFromDate(date!)
    countdownLabel.text = Strings.countdownText(forSunEvent: currentSunEvent!)
    setDayTheme()
  }
  
  private func setDayTheme() {
    dayGradientView.hidden = false
    nightGradientView.hidden = true
  }
  
  private func setNightTheme() {
    dayGradientView.hidden = true
    nightGradientView.hidden = false
  }
  
  func previousSunEventViewTapped() {
    togglePreviousSunEventView()
    if nextSunEventViewIsVisible() {
      toggleNextSunEventView()
    }
  }
  
  func nextSunEventViewTapped() {
    toggleNextSunEventView()
    if previousSunEventViewIsVisible() {
      togglePreviousSunEventView()
    }
  }
  
  func togglePreviousSunEventView() {
    if previousSunEventViewLeadingConstraint.constant == 0 {
      previousSunEventViewLeadingConstraint.constant = -(previousSunEventView.frame.size.width - 40)
    }
    else {
      previousSunEventViewLeadingConstraint.constant = 0
    }
    
    UIView.animateWithDuration(0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  func toggleNextSunEventView() {
    if nextSunEventViewTrailingConstraint.constant == 0 {
      nextSunEventViewTrailingConstraint.constant = -(nextSunEventView.frame.size.width - 40)
    }
    else {
      nextSunEventViewTrailingConstraint.constant = 0
    }
    
    UIView.animateWithDuration(0.3) {
      self.view.layoutIfNeeded()
    }
  }
  
  func previousSunEventViewIsVisible() -> Bool {
    return previousSunEventViewLeadingConstraint.constant == 0
  }
  
  func nextSunEventViewIsVisible() -> Bool {
    return nextSunEventViewTrailingConstraint.constant == 0
  }
  
  @IBAction func settingsButtonTapped(sender: UIButton) {
    delegate?.settingsButtonTapped()
  }
}