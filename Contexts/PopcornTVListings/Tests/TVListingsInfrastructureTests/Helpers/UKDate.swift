//
//  UKDate.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

///
/// Builds a `Date` for the given components in the `Europe/London` time zone, so tests
/// bucket programmes into UK calendar days regardless of the host time zone.
///
func ukDate(year: Int, month: Int, day: Int, hour: Int, minute: Int = 0) -> Date {
    guard let timeZone = TimeZone(identifier: "Europe/London") else {
        return .distantPast
    }
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    components.timeZone = timeZone
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = timeZone
    return calendar.date(from: components) ?? .distantPast
}
