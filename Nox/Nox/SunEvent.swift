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

extension SunEvent: Equatable {}
func ==(lhs: SunEvent, rhs: SunEvent) -> Bool {
  return lhs.date.compare(rhs.date) == .OrderedSame
}

func !=(lhs: SunEvent, rhs: SunEvent) -> Bool {
  return !(lhs == rhs)
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
  
  func get(numberOfSunrises numSunrises: Int) -> [SunEvent] {
    var sunrises = [SunEvent]()
    var date = NSDate().dateByAddingTimeInterval(-NSDate().secondsInDay)
    while sunrises.count < numSunrises {
      date = date.dateByAddingTimeInterval(date.secondsInDay)
      let sunrise = getSunrise(forDate: date)
      if sunrise.date.isInFuture {
        let sunset = getSunset(forDate: date)
        if sunrise != sunset {
          sunrises.append(sunrise)
        }
      }
    }
    return sunrises
  }
  
  func get(numberOfSunsets numSunsets: Int) -> [SunEvent] {
    var sunsets = [SunEvent]()
    var date = NSDate().dateByAddingTimeInterval(-NSDate().secondsInDay)
    while sunsets.count < numSunsets {
      date = date.dateByAddingTimeInterval(date.secondsInDay)
      let sunset = getSunset(forDate: date)
      if sunset.date.isInFuture {
        let sunrise = getSunrise(forDate: date)
        if sunset != sunrise {
          sunsets.append(sunset)
        }
      }
    }
    return sunsets
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