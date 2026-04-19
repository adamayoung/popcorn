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
        guard let timeZone = TimeZone(identifier: "Europe/London") else {
            preconditionFailure(
                "Europe/London time zone unavailable; UK day-bucketing would silently use the device time zone."
            )
        }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return calendar
    }()

}
