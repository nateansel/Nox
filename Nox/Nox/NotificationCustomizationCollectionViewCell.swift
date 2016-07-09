//
//  NotificationCustomizationCollectionViewCell.swift
//  Nox
//
//  Created by Nathan Ansel on 7/2/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit

class NotificationCustomizationCollectionViewCell: UICollectionViewCell {

  @IBOutlet weak private var label: UILabel!
  
  var timeText: String? {
    didSet {
      label.text = timeText
    }
  }
  
  override var selected: Bool {
    didSet {
      setColors(selected)
    }
  }
  
  override var highlighted: Bool {
    didSet {
      setColors(highlighted)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.cornerRadius = 16.0
    layer.borderColor  = UIColor.whiteColor().CGColor
    layer.borderWidth  = 2.0
  }
  
  private func setColors(highlighted: Bool) {
    if highlighted {
      backgroundColor = UIColor(white: 1, alpha: 0.25)
    }
    else {
      backgroundColor = UIColor.clearColor()
    }
  }
}
