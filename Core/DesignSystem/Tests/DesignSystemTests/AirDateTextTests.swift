//
//  AirDateTextTests.swift
//  DesignSystem
//
//  Copyright © 2026 Adam Young.
//

@testable import DesignSystem
import Foundation
import Testing

@Suite("AirDateText")
struct AirDateTextTests {

    let calendar: Calendar
    let now: Date

    init() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try #require(TimeZone(identifier: "UTC"))
        self.calendar = calendar
        // Fixed "now": 2026-02-23 12:00:00 UTC
        self.now = Date(timeIntervalSince1970: 1_771_848_000)
    }

    @Test("classifies today as aired")
    func classifiesTodayAsAired() {
        let result = AirDateText.classify(
            date: now, now: now, calendar: calendar
        )

        #expect(result == .aired)
    }

    @Test("classifies past date as aired")
    func classifiesPastDateAsAired() throws {
        let yesterday = try #require(calendar.date(
            byAdding: .day, value: -1, to: now
        ))

        let result = AirDateText.classify(
            date: yesterday, now: now, calendar: calendar
        )

        #expect(result == .aired)
    }

    @Test("classifies 1 day ahead as coming soon")
    func classifiesOneDayAheadAsComingSoon() throws {
        let tomorrow = try #require(calendar.date(
            byAdding: .day, value: 1, to: now
        ))

        let result = AirDateText.classify(
            date: tomorrow, now: now, calendar: calendar
        )

        #expect(result == .comingSoon)
    }

    @Test("classifies 7 days ahead as coming soon")
    func classifiesSevenDaysAheadAsComingSoon() throws {
        let sevenDays = try #require(calendar.date(
            byAdding: .day, value: 7, to: now
        ))

        let result = AirDateText.classify(
            date: sevenDays, now: now, calendar: calendar
        )

        #expect(result == .comingSoon)
    }

    @Test("classifies 8 days ahead as coming later")
    func classifiesEightDaysAheadAsComingLater() throws {
        let eightDays = try #require(calendar.date(
            byAdding: .day, value: 8, to: now
        ))

        let result = AirDateText.classify(
            date: eightDays, now: now, calendar: calendar
        )

        #expect(result == .comingLater)
    }

    @Test("classifies far future date as coming later")
    func classifiesFarFutureAsComingLater() throws {
        let farFuture = try #require(calendar.date(
            byAdding: .month, value: 3, to: now
        ))

        let result = AirDateText.classify(
            date: farFuture, now: now, calendar: calendar
        )

        #expect(result == .comingLater)
    }

}
