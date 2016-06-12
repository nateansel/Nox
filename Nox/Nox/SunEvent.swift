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
  
  var date: NSDate {
    switch self {
    case .Sunrise(let date):
      return date
    case .Sunset(let date):
      return date
    }
  }
  
  func next() -> SunEvent {
    return SunEventService().getNextSunEvent()
  }
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
  
  func getNextSunEvent() -> SunEvent {
    var date = NSDate()
    while true {
      let sunrise = getSunrise(forDate: date)
      let sunset = getSunrise(forDate: date)
      if sunrise.date.compare(sunset.date) != .OrderedSame {
        if sunrise.date.isInFuture {
          return sunrise
        }
        if sunset.date.isInFuture {
          return sunset
        }
      }
      date = date.dateByAddingTimeInterval(NSDate.secondsInDay)
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
    return SunEvent.Sunset(sunrise)
  }
}

extension NSDate {
  var isInFuture: Bool {
    return self.timeIntervalSinceNow > 0
  }
  var secondsInDay: Double {
    return 86400.0
  }
}


