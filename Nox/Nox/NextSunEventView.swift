//
//  PreviousSunEventView.swift
//  Nox
//
//  Created by Chase McCoy on 7/17/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit

class NextSunEventView: UIView {
  @IBOutlet var view: UIView!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    NSBundle.mainBundle().loadNibNamed(String(NextSunEventView), owner: self, options: nil)
    view.frame = self.bounds
    configure()
    self.addSubview(self.view)
  }
  
  private func configure() {
    self.backgroundColor = UIColor.clearColor()
    view.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
    view.roundCorners([.TopLeft, .BottomLeft], radius: 12)
  }
}

