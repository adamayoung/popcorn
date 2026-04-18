//
//  Calendar+UK.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import Foundation

extension Calendar {

    ///
    /// The Gregorian calendar fixed to the `Europe/London` time zone. Used to bucket
    /// programmes into UK calendar days regardless of the user's device time zone.
    ///
    static let ukGregorian: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        if let timeZone = TimeZone(identifier: "Europe/London") {
            calendar.timeZone = timeZone
        }
        return calendar
    }()

}
