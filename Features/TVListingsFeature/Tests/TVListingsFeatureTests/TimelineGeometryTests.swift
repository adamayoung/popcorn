//
//  TimelineGeometryTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

// MARK: - Canon TDD Test List

//
// x(for:)
//   - [x] date == origin -> 0
//   - [x] date 30 min after origin -> 90 (at 3 ppm)
//   - [x] date 1 min after origin -> 3
//   - [x] date BEFORE origin -> 0 (clamped, never negative)
//
// width(from:to:)
//   - [x] normal 30-min programme -> 90
//   - [x] programme starting before origin (origin-20m .. origin+40m) -> 120 (measured from origin)
//   - [x] very short programme below minBlockWidth -> minBlockWidth
//   - [x] start == end -> minBlockWidth (never 0/negative)
//   - [x] end before start -> minBlockWidth (never negative)
//
// flooringNow(_:)
//   - [x] now at 20:17 London -> origin 20:00
//   - [x] now at 20:45 London -> origin 20:30
//   - [x] now exactly on a boundary 20:00 -> origin 20:00
//   - [x] floor honours injected Europe/London time zone (known instant)
//
// slotBoundaries(until:)
//   - [x] returns origin, +30, +60 ...
//   - [x] count correct / honours `until` (inclusive of a boundary == until)
//   - [x] until before origin -> [origin] only
//
// nowX(at:)
//   - [x] equals x(for: now)
//
// totalWidth(end:)
//   - [x] equals x(for: end)
//
// visibleRange(forContentOffsetX:viewportWidth:)
//   - [x] offsetX 0, viewport 300 at 3ppm -> origin ... origin+100min
//   - [x] offsetX 90 -> starts at origin+30min
//   - [x] inverse-consistent with x(for:)
//
// Conformances
//   - [x] Equatable / Sendable compile & behave
//

import CoreGraphics
import Foundation
import Testing
@testable import TVListingsFeature

@Suite("TimelineGeometry Tests")
struct TimelineGeometryTests {

    // MARK: - x(for:)

    @Test("x(for:) returns 0 at the origin")
    func xAtOriginIsZero() {
        let geometry = Self.makeGeometry(origin: Self.origin)

        #expect(geometry.x(for: Self.origin) == 0)
    }

    @Test("x(for:) returns 90 for a date 30 minutes after origin at 3 ppm")
    func xThirtyMinutesAfterOrigin() {
        let geometry = Self.makeGeometry(origin: Self.origin)

        #expect(geometry.x(for: Self.origin.addingTimeInterval(30 * 60)) == 90)
    }

    @Test("x(for:) returns 3 for a date 1 minute after origin at 3 ppm")
    func xOneMinuteAfterOrigin() {
        let geometry = Self.makeGeometry(origin: Self.origin)

        #expect(geometry.x(for: Self.origin.addingTimeInterval(60)) == 3)
    }

    @Test("x(for:) clamps dates before origin to 0")
    func xBeforeOriginClampsToZero() {
        let geometry = Self.makeGeometry(origin: Self.origin)

        #expect(geometry.x(for: Self.origin.addingTimeInterval(-30 * 60)) == 0)
    }

    // MARK: - width(from:to:)

    @Test("width(from:to:) returns 90 for a normal 30-minute programme")
    func widthForThirtyMinuteProgramme() {
        let geometry = Self.makeGeometry(origin: Self.origin)
        let start = Self.origin.addingTimeInterval(60 * 60)
        let end = start.addingTimeInterval(30 * 60)

        #expect(geometry.width(from: start, to: end) == 90)
    }

    @Test("width(from:to:) measures from origin when the programme starts before it")
    func widthClampsStartToOrigin() {
        let geometry = Self.makeGeometry(origin: Self.origin)
        let start = Self.origin.addingTimeInterval(-20 * 60)
        let end = Self.origin.addingTimeInterval(40 * 60)

        // Measured from origin (40 min), not from start (60 min) -> 120, not 180.
        #expect(geometry.width(from: start, to: end) == 120)
    }

    @Test("width(from:to:) floors a very short programme at minBlockWidth")
    func widthFloorsShortProgramme() {
        let geometry = Self.makeGeometry(origin: Self.origin)
        let start = Self.origin.addingTimeInterval(60 * 60)
        let end = start.addingTimeInterval(60) // 1 minute -> 3pt, below 44

        #expect(geometry.width(from: start, to: end) == 44)
    }

    @Test("width(from:to:) returns minBlockWidth when start == end")
    func widthForZeroLengthProgramme() {
        let geometry = Self.makeGeometry(origin: Self.origin)
        let start = Self.origin.addingTimeInterval(60 * 60)

        #expect(geometry.width(from: start, to: start) == 44)
    }

    @Test("width(from:to:) returns minBlockWidth when end is before start")
    func widthForNegativeProgramme() {
        let geometry = Self.makeGeometry(origin: Self.origin)
        let start = Self.origin.addingTimeInterval(60 * 60)
        let end = start.addingTimeInterval(-30 * 60)

        #expect(geometry.width(from: start, to: end) == 44)
    }

    // MARK: - flooringNow(_:)

    @Test("flooringNow floors 20:17 to a 20:00 origin")
    func flooringNowFloorsToHalfHourBelow() {
        let now = Self.londonDate(hour: 20, minute: 17)

        let geometry = TimelineGeometry.flooringNow(now)

        #expect(geometry.origin == Self.londonDate(hour: 20, minute: 0))
    }

    @Test("flooringNow floors 20:45 to a 20:30 origin")
    func flooringNowFloorsToHalfHour() {
        let now = Self.londonDate(hour: 20, minute: 45)

        let geometry = TimelineGeometry.flooringNow(now)

        #expect(geometry.origin == Self.londonDate(hour: 20, minute: 30))
    }

    @Test("flooringNow keeps an exact boundary unchanged")
    func flooringNowOnBoundaryIsUnchanged() {
        let now = Self.londonDate(hour: 20, minute: 0)

        let geometry = TimelineGeometry.flooringNow(now)

        #expect(geometry.origin == now)
    }

    @Test("flooringNow floors using the Europe/London time zone")
    func flooringNowUsesLondonTimeZone() {
        // 19:17 UTC on 2026-06-11 is 20:17 BST (London is UTC+1 in summer),
        // which must floor to 20:00 BST == 19:00 UTC.
        let now = Date(timeIntervalSince1970: 1_781_205_420) // 2026-06-11T19:17:00Z
        let expectedOrigin = Date(timeIntervalSince1970: 1_781_204_400) // 2026-06-11T19:00:00Z

        let geometry = TimelineGeometry.flooringNow(now)

        #expect(geometry.origin == expectedOrigin)
    }

    // MARK: - slotBoundaries(until:)

    @Test("slotBoundaries returns origin and successive slot starts up to until")
    func slotBoundariesAreEvenlySpaced() {
        let geometry = Self.makeGeometry(origin: Self.origin)
        let until = Self.origin.addingTimeInterval(90 * 60)

        let boundaries = geometry.slotBoundaries(until: until)

        #expect(boundaries == [
            Self.origin,
            Self.origin.addingTimeInterval(30 * 60),
            Self.origin.addingTimeInterval(60 * 60),
            Self.origin.addingTimeInterval(90 * 60)
        ])
    }

    @Test("slotBoundaries stops before a non-boundary until")
    func slotBoundariesHonourUntil() {
        let geometry = Self.makeGeometry(origin: Self.origin)
        let until = Self.origin.addingTimeInterval(75 * 60)

        let boundaries = geometry.slotBoundaries(until: until)

        #expect(boundaries == [
            Self.origin,
            Self.origin.addingTimeInterval(30 * 60),
            Self.origin.addingTimeInterval(60 * 60)
        ])
    }

    @Test("slotBoundaries returns only the origin when until is before origin")
    func slotBoundariesUntilBeforeOrigin() {
        let geometry = Self.makeGeometry(origin: Self.origin)
        let until = Self.origin.addingTimeInterval(-30 * 60)

        #expect(geometry.slotBoundaries(until: until) == [Self.origin])
    }

    // MARK: - nowX(at:) & totalWidth(end:)

    @Test("nowX(at:) equals x(for:)")
    func nowXEqualsX() {
        let geometry = Self.makeGeometry(origin: Self.origin)
        let now = Self.origin.addingTimeInterval(42 * 60)

        #expect(geometry.nowX(at: now) == geometry.x(for: now))
    }

    @Test("totalWidth(end:) equals x(for:)")
    func totalWidthEqualsX() {
        let geometry = Self.makeGeometry(origin: Self.origin)
        let end = Self.origin.addingTimeInterval(200 * 60)

        #expect(geometry.totalWidth(end: end) == geometry.x(for: end))
    }

    // MARK: - visibleRange(forContentOffsetX:viewportWidth:)

    @Test("visibleRange at offset 0 covers origin to origin+100min for a 300pt viewport")
    func visibleRangeAtZeroOffset() {
        let geometry = Self.makeGeometry(origin: Self.origin)

        let range = geometry.visibleRange(forContentOffsetX: 0, viewportWidth: 300)

        #expect(range.lowerBound == Self.origin)
        #expect(range.upperBound == Self.origin.addingTimeInterval(100 * 60))
    }

    @Test("visibleRange at offset 90 starts at origin+30min")
    func visibleRangeAtOffset() {
        let geometry = Self.makeGeometry(origin: Self.origin)

        let range = geometry.visibleRange(forContentOffsetX: 90, viewportWidth: 300)

        #expect(range.lowerBound == Self.origin.addingTimeInterval(30 * 60))
        #expect(range.upperBound == Self.origin.addingTimeInterval(130 * 60))
    }

    @Test("visibleRange is inverse-consistent with x(for:)")
    func visibleRangeIsInverseOfX() {
        let geometry = Self.makeGeometry(origin: Self.origin)

        let range = geometry.visibleRange(forContentOffsetX: 150, viewportWidth: 300)

        #expect(geometry.x(for: range.lowerBound) == 150)
        #expect(geometry.x(for: range.upperBound) == 450)
    }

    // MARK: - Conformances

    @Test("Equatable distinguishes differing origins")
    func equatableConformance() {
        let first = Self.makeGeometry(origin: Self.origin)
        let second = Self.makeGeometry(origin: Self.origin)
        let shifted = Self.makeGeometry(origin: Self.origin.addingTimeInterval(60))

        #expect(first == second)
        #expect(first != shifted)
    }

    @Test("is Sendable")
    func sendableConformance() {
        func requireSendable(_: some Sendable) {}
        requireSendable(Self.makeGeometry(origin: Self.origin))
    }

}

// MARK: - Factories & Fixtures

extension TimelineGeometryTests {

    /// A fixed origin: 2026-06-11 20:00 Europe/London.
    static let origin = Self.londonDate(hour: 20, minute: 0)

    static func makeGeometry(
        origin: Date,
        pixelsPerMinute: CGFloat = 3,
        slotMinutes: Int = 30,
        minBlockWidth: CGFloat = 44
    ) -> TimelineGeometry {
        TimelineGeometry(
            origin: origin,
            pixelsPerMinute: pixelsPerMinute,
            slotMinutes: slotMinutes,
            minBlockWidth: minBlockWidth
        )
    }

    /// Builds a `Date` on 2026-06-11 at the given time in `Europe/London`.
    static func londonDate(hour: Int, minute: Int) -> Date {
        guard let timeZone = TimeZone(identifier: "Europe/London") else {
            return .distantPast
        }
        var components = DateComponents()
        components.year = 2026
        components.month = 6
        components.day = 11
        components.hour = hour
        components.minute = minute
        components.timeZone = timeZone
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone
        return calendar.date(from: components) ?? .distantPast
    }

}
