//
//  Calculator.swift
//  Nox
//
//  Created by Nathan Ansel on 5/15/16.
//  Copyright © 2016 Chase McCoy. All rights reserved.
//

import UIKit

let zenithGeometric: CGFloat = 90.0

class Calculator {
  
  private var location: Location!
  
  init(location: Location) {
    self.location = location
  }
  
  func getSunrise(forDate date: NSDate) -> NSDate {
    
    return NSDate()
  }
  
  func getSunset(forDate date: NSDate) -> NSDate {
    
    return NSDate()
  }
  
  private func sunrise(forDate date: NSDate, zenith: CGFloat, elevation: CGFloat) {
    let newZenith = adjust(zenith: zenith, elevation: elevation)
    let dateParts = yearMonthDay(date: date)
    let year = dateParts[0]
    let month = dateParts[1]
    let day = dateParts[2]
  }
  
  private func adjust(zenith zenith: CGFloat, elevation: CGFloat) -> CGFloat {
    // TODO: calclate the new zenith
    return zenith
  }
  
  private func yearMonthDay(date date: NSDate) -> [Int] {
    let gregorianCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    let dateComponents = gregorianCalendar?.components([.Year, .Month, .Day], fromDate: date)
    let partsList = [dateComponents!.year, dateComponents!.month, dateComponents!.day]
    return partsList
  }
  
  - (double)UTCSunriseForDate:(NSDate*)date andZenith:(double)zenith adjustForElevation:(BOOL)adjustForElevation
  {
  
  double doubleTime = NAN;
  
  if (adjustForElevation)
  {
  zenith = [self adjustZenith:zenith forElevation:self.geoLocation.altitude];
  }
  else
  {
  zenith = [self adjustZenith:zenith forElevation:0];
  }
  
  int year = [[self yearMonthAndDayFromDate:date][0]intValue];
  
  int month = [[self yearMonthAndDayFromDate:date][1]intValue];
  
  int day = [[self yearMonthAndDayFromDate:date][2]intValue];
  
  
  doubleTime = [self sunriseOrSunsetForYear:year andMonth:month andDay:day atLongitude:self.geoLocation.longitude andLatitude:self.geoLocation.latitude withZenith:zenith andType:kTypeSunrise];
  
  return doubleTime;
  }
  
  
  
  
  
}
