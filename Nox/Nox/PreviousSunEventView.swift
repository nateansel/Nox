//
//  PreviousSunEventView.swift
//  Nox
//
//  Created by Chase McCoy on 7/17/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit

class PreviousSunEventView: UIView {
  @IBOutlet var view: UIView!
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    NSBundle.mainBundle().loadNibNamed(String(self), owner: self, options: nil)
    self.addSubview(self.view)
  }
}

