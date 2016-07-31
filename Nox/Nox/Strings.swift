//
//  Strings.swift
//  Nox
//
//  Created by Nathan Ansel on 5/29/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import Foundation

enum Strings {
  static let sunriseDescription = "The sun will rise at"
  static let sunsetDescription = "The sun will set at"
  
  enum Settings {
    static let twelveHourTime              = "twelveHourTime"
    static let notificationsArray          = "notificationsArray"
    static let sunriseNotificationStatus   = "sunriseNotificationStatus"
    static let sunsetNotificationStatus    = "sunsetNotificationStatus"
    static let sunriseNotificationSettings = "sunriseNotificationSettings"
    static let sunsetNotificationSettings  = "sunsetNotificationSettings"
  }
}

extension Strings {
  static func countdownText(forSunEvent sunEvent: SunEvent) -> String {
    let date = sunEvent.date
    var timeUntilSunEvent = date.timeIntervalSinceNow
    var hours = Int(timeUntilSunEvent / 3600)
    timeUntilSunEvent %= 3600
    var minutes = Int(timeUntilSunEvent / 60)
    if minutes > 45 {
      hours += 1
      minutes = 0
    }
    let days = Int(hours / 24)
    hours %= 24
    
    // Build days string
    var dayString = ""
    if days > 0 {
      dayString = "\(days) day"
      if days > 1 {
        dayString += "s"
      }
      dayString += " "
    }
    
    // Add minutes to string
    var minuteString = ""
    if minutes > 30 {
      minuteString = "¾ "
    }
    else if minutes > 15 {
      minuteString = "½ "
    }
    else if minutes != 0 {
      minuteString = "¼"
    }
    
    // Add hours to string
    var hourString = ""
    if hours > 0 {
      hourString = "\(hours)\(minuteString) hour"
      if hours > 1 || (hours == 1 && minuteString != "") {
        hourString += "s"
      }
      hourString += " "
    }
    
    if dayString != "" || hourString != "" || minuteString != "" {
      switch sunEvent {
      case .Sunrise:
        return dayString + hourString + "until the sun rises."
      case .Sunset:
        return dayString + hourString + "of sunlight left."
      }
    }
    
    if minutes < 5 {
      switch sunEvent {
      case .Sunrise:
        return "Sunrise is imminent."
      case .Sunset:
        return "Sunset is imminent."
      }
    }
    
    switch sunEvent {
    case .Sunrise:
      return "\(minutes) minutes until the sun rises."
    case .Sunset:
      return "\(minutes) minutes of sunlight left."
    }
  }
  
  /// Builds a string from the number of minutes passed in.
  ///   Example: 155 -> "2 hours 45 minutes"
  static func timeString(fromMinutes minutes: Int) -> String {
    let hours = Int(minutes / 60)
    let newMinutes = minutes % 60
    var hourString = ""
    var minuteString = ""
    if hours > 0 {
      hourString = "\(hours) hour"
      if hours > 1 {
        hourString += "s"
      }
      if newMinutes > 0 {
        hourString += " "
      }
    }
    if newMinutes > 0 {
      minuteString = "\(newMinutes) minutes"
    }
    return hourString + minuteString
  }
}
