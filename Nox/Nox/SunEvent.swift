//
//  SunEvent.swift
//  Nox
//
//  Created by Nathan Ansel on 5/29/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import Foundation
import KosherCocoa
import CoreLocation

enum SunEvent {
  case Sunrise(NSDate)
  case Sunset(NSDate)
}

// MARK: SunEventService

/// 
///
class SunEventService {
  
  // MARK: Properties
  
  var location: CLLocation {
    didSet {
      let geoLocation = KCGeoLocation(
        latitude: location.coordinate.latitude,
        andLongitude: location.coordinate.longitude,
        andTimeZone: NSTimeZone.systemTimeZone())
      calendar.geoLocation = geoLocation
    }
  }
  
  private var calendar: KCAstronomicalCalendar
  
  // MARK: - Methods
  
  // MARK: Init
  
  init(location: CLLocation) {
    self.location = location
    let geoLocation = KCGeoLocation(
      latitude: location.coordinate.latitude,
      andLongitude: location.coordinate.longitude,
      andTimeZone: NSTimeZone.systemTimeZone())
    calendar = KCAstronomicalCalendar(location: geoLocation)
  }
  
  // MARK: Retrieval
  
  func getSunset(forDate date: NSDate) -> SunEvent {
    calendar.workingDate = date
    let sunset = calendar.sunset()
    return SunEvent.Sunset(sunset)
  }
  
  func getSunrise(forDate date: NSDate) -> SunEvent {
    calendar.workingDate = date
    let sunrise = calendar.sunrise()
    return SunEvent.Sunset(sunrise)
  }
}