//
//  SunEvent.swift
//  Nox
//
//  Created by Nathan Ansel on 5/29/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit
import KosherCocoa
import CoreLocation

enum SunEvent {
  case Sunrise(NSDate)
  case Sunset(NSDate)
  
  var date: NSDate {
    switch self {
    case .Sunrise(let date):
      return date
    case .Sunset(let date):
      return date
    }
  }
}

// MARK: SunEventService

/// 
///
class SunEventService {
  
  // MARK: Properties
  
  var location: CLLocation! {
    didSet {
      initializeCalendar(withLocation: location)
    }
  }
  
  private var calendar = KCAstronomicalCalendar()
  
  // MARK: - Methods
  
  // MARK: Init
  
  convenience init(location: CLLocation) {
    self.init()
    self.location = location
    initializeCalendar(withLocation: location)
  }
  
  // MARK: Retrieval
  
  func getNextSunEvent() -> SunEvent {
    var date = NSDate()
    while true {
      let sunrise = getSunrise(forDate: date)
      let sunset = getSunset(forDate: date)
      if sunrise.date.compare(sunset.date) != .OrderedSame {
        if sunrise.date.isInFuture {
          return sunrise
        }
        if sunset.date.isInFuture {
          return sunset
        }
      }
      date = date.dateByAddingTimeInterval(NSDate().secondsInDay)
    }
  }
  
  func getSunset(forDate date: NSDate) -> SunEvent {
    calendar.workingDate = date
    let sunset = calendar.sunset()
    return SunEvent.Sunset(sunset)
  }
  
  func getSunrise(forDate date: NSDate) -> SunEvent {
    calendar.workingDate = date
    let sunrise = calendar.sunrise()
    return SunEvent.Sunrise(sunrise)
  }
  
  // MARK: Convenience
  
  func initializeCalendar(withLocation location: CLLocation) {
    let geoLocation = KCGeoLocation(
      latitude: location.coordinate.latitude,
      andLongitude: location.coordinate.longitude,
      andTimeZone: NSTimeZone.systemTimeZone())
    calendar = KCAstronomicalCalendar(location: geoLocation)
  }
}

extension NSDate {
  var isInFuture: Bool {
    return self.timeIntervalSinceNow > 0
  }
  
  var secondsInDay: Double {
    return 86400.00
  }
}