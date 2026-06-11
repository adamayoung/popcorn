//
//  TimelineGeometry.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import CoreGraphics
import Foundation

/// Maps absolute times onto the horizontal axis of an EPG timeline grid.
///
/// `TimelineGeometry` is a pure value type (no SwiftUI) that converts between
/// `Date`s and x-offsets in points, so the same maths can drive layout, the
/// "now" indicator, slot ruling, and viewport culling.
///
/// The axis is absolute-time based: x grows linearly with elapsed minutes since
/// ``origin`` at ``pixelsPerMinute`` points per minute. A calendar fixed to the
/// supplied time zone (`Europe/London` by default) is used only for flooring
/// `now` to a slot boundary, so daylight-saving transitions don't shift the
/// pixel mapping.
public struct TimelineGeometry: Equatable, Sendable {

    /// The (floored) start of the timeline. `x(for: origin) == 0`.
    public let origin: Date

    /// Points per minute along the horizontal axis.
    public let pixelsPerMinute: CGFloat

    /// Length of a single slot (and the spacing between slot boundaries), in minutes.
    public let slotMinutes: Int

    /// The minimum rendered width of a programme block, in points.
    public let minBlockWidth: CGFloat

    /// The time zone used to floor `now` to a slot boundary.
    public let timeZone: TimeZone

    public init(
        origin: Date,
        pixelsPerMinute: CGFloat = 3,
        slotMinutes: Int = 30,
        minBlockWidth: CGFloat = 44,
        timeZone: TimeZone = TimeZone(identifier: "Europe/London") ?? .gmt
    ) {
        self.origin = origin
        self.pixelsPerMinute = pixelsPerMinute
        self.slotMinutes = slotMinutes
        self.minBlockWidth = minBlockWidth
        self.timeZone = timeZone
    }

    /// Builds a geometry whose ``origin`` is `now` floored to the previous slot
    /// boundary (e.g. `:00` / `:30`) in `timeZone`.
    public static func flooringNow(
        _ now: Date,
        pixelsPerMinute: CGFloat = 3,
        slotMinutes: Int = 30,
        minBlockWidth: CGFloat = 44,
        timeZone: TimeZone = TimeZone(identifier: "Europe/London") ?? .gmt
    ) -> TimelineGeometry {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = timeZone

        // Start of the clock hour containing `now`, then add whole slots until
        // the next boundary would pass `now`. Working from the hour start keeps
        // the floor aligned to wall-clock `:00` / `:30` marks in `timeZone`.
        let hourStart = calendar.dateInterval(of: .hour, for: now)?.start ?? now
        let slotInterval = Double(slotMinutes) * 60
        var origin = hourStart
        while origin.addingTimeInterval(slotInterval) <= now {
            origin = origin.addingTimeInterval(slotInterval)
        }

        return TimelineGeometry(
            origin: origin,
            pixelsPerMinute: pixelsPerMinute,
            slotMinutes: slotMinutes,
            minBlockWidth: minBlockWidth,
            timeZone: timeZone
        )
    }

    // MARK: - Positioning

    /// The x-offset (points) for `date`, clamped to be non-negative so dates
    /// before ``origin`` pin to the start of the axis.
    public func x(for date: Date) -> CGFloat {
        let minutes = date.timeIntervalSince(origin) / 60
        let offset = CGFloat(minutes) * pixelsPerMinute
        return max(0, offset)
    }

    /// The width (points) of a programme spanning `start..end`, measured from
    /// `max(start, origin)` so programmes starting before the timeline are
    /// clipped to the axis. Never smaller than ``minBlockWidth`` (so zero- or
    /// negative-length programmes still render).
    public func width(from start: Date, to end: Date) -> CGFloat {
        let clippedStart = max(start, origin)
        let minutes = end.timeIntervalSince(clippedStart) / 60
        let span = CGFloat(minutes) * pixelsPerMinute
        return max(minBlockWidth, span)
    }

    /// The total content width needed to render the axis out to `end`.
    public func totalWidth(end: Date) -> CGFloat {
        x(for: end)
    }

    /// The x-offset (points) of the "now" indicator at `now`.
    public func nowX(at now: Date) -> CGFloat {
        x(for: now)
    }

    // MARK: - Ruling

    /// The slot-boundary dates from ``origin`` up to and including `until`.
    ///
    /// Always contains ``origin``; subsequent entries step by ``slotMinutes``
    /// and stop at the last boundary that is `<= until`.
    public func slotBoundaries(until end: Date) -> [Date] {
        let slotInterval = Double(slotMinutes) * 60
        var boundaries: [Date] = [origin]
        var next = origin.addingTimeInterval(slotInterval)
        while next <= end {
            boundaries.append(next)
            next = next.addingTimeInterval(slotInterval)
        }
        return boundaries
    }

    // MARK: - Viewport

    /// The inverse of ``x(for:)``: the absolute-time range visible for a
    /// horizontal scroll offset and viewport width.
    public func visibleRange(
        forContentOffsetX offsetX: CGFloat,
        viewportWidth: CGFloat
    ) -> ClosedRange<Date> {
        let lower = date(forX: offsetX)
        let upper = date(forX: offsetX + viewportWidth)
        return lower ... upper
    }

    /// The absolute time at x-offset `offset` (the inverse of ``x(for:)``).
    private func date(forX offset: CGFloat) -> Date {
        let minutes = Double(offset / pixelsPerMinute)
        return origin.addingTimeInterval(minutes * 60)
    }

}
