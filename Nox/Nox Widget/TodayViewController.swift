//
//  TodayViewController.swift
//  Nox Widget
//
//  Created by Nathan Ansel on 7/31/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit
import NotificationCenter

protocol TodayViewControllerDelegate {
  func getNextSunEvent()
}

class TodayViewController: UIViewController, NCWidgetProviding {
  
  var delegate: NCWidgetCoordinator?
  var sunEvent: SunEvent? {
    didSet {
      if let sunEvent = sunEvent {
        switch sunEvent {
        case .Sunrise:
          setSunriseData()
        case .Sunset:
          setSunsetData()
        }
      }
    }
  }
  let dateFormatter: NSDateFormatter = {
    $0.dateFormat = "h:mm a"
    return $0
  }(NSDateFormatter())
  
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var countdownLabel: UILabel!
        
  override func viewDidLoad() {
    super.viewDidLoad()
    let coordinator = NCWidgetCoordinator()
    coordinator.todayViewController = self
    coordinator.start()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    delegate?.getNextSunEvent()
  }
  
  func setSunriseData() {
    descriptionLabel.text = Strings.sunriseDescription
    timeLabel.text = dateFormatter.stringFromDate(sunEvent!.date)
    countdownLabel.text = Strings.countdownText(forSunEvent: sunEvent!)
  }
  
  func setSunsetData() {
    descriptionLabel.text = Strings.sunsetDescription
    timeLabel.text = dateFormatter.stringFromDate(sunEvent!.date)
    countdownLabel.text = Strings.countdownText(forSunEvent: sunEvent!)
  }
  
  func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsetsZero
  }
  
  func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.

    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData

    completionHandler(NCUpdateResult.NewData)
  }
}
