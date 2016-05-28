//
//  Location.swift
//  Nox
//
//  Created by Nathan Ansel on 5/15/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit
import CoreLocation

class Location {
  
  private var location: CLLocation!
  private var timeZone: NSTimeZone!
  private var elevation: CGFloat!
  
  init(location: CLLocation) {
    self.location = location
    timeZone = NSTimeZone.systemTimeZone()
    elevation = 0
  }
  
  
  
  
}