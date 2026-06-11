//
//  EPGLayout.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import CoreGraphics
import Foundation

/// Pure layout helpers for the EPG grid: viewport windowing and the
/// narrow-block decision. Kept separate from the SwiftUI views so the
/// non-trivial filtering/threshold logic can be unit-tested directly.
enum EPGLayout {

    /// The minimum rendered block width (points) at or below which a programme
    /// block renders in its compact, title-only form.
    static let narrowBlockThreshold: CGFloat = 80

    /// Whether a block of `width` points should render in its compact form.
    static func isNarrow(width: CGFloat, threshold: CGFloat = narrowBlockThreshold) -> Bool {
        width < threshold
    }

    /// The far edge of the timeline: the latest programme end across all rows,
    /// falling back to `now` for an entirely empty grid (so the timeline is
    /// never zero-width).
    static func timelineEnd(rows: [TVListingsChannelRow], now: Date) -> Date {
        let latestEnd = rows
            .flatMap(\.programmes)
            .map(\.programme.endTime)
            .max()
        return latestEnd ?? now
    }

    /// The content x-offset to scroll to so "now" sits one-third in from the
    /// leading edge, clamped to the content origin so it never scrolls negative.
    static func autoScrollTargetX(nowX: CGFloat, viewportWidth: CGFloat) -> CGFloat {
        max(0, nowX - viewportWidth / 3)
    }

    /// A `HH:mm` clock label for `date` in `timeZone` (Europe/London), used by
    /// the time-header ruler and programme blocks.
    static func timeLabel(for date: Date, timeZone: TimeZone) -> String {
        date.formatted(
            Date.FormatStyle(date: .omitted, time: .shortened, timeZone: timeZone)
                .hour(.twoDigits(amPM: .omitted))
                .minute(.twoDigits)
        )
    }

    /// The 1–3 uppercase initials for `name`: the first letter of each of the
    /// first three words (split on spaces/hyphens), falling back to the first
    /// two characters when the name has no letters to take initials from.
    static func channelInitials(for name: String) -> String {
        let words = name
            .split(whereSeparator: { $0 == " " || $0 == "-" })
            .prefix(3)
        let letters = words.compactMap(\.first)
        if letters.isEmpty {
            return String(name.prefix(2)).uppercased()
        }
        return String(letters).uppercased()
    }

    /// The rendered width of a block, clamped so it never overruns the next
    /// programme's start.
    ///
    /// `rawWidth` is the geometry width (already floored at `minBlockWidth`).
    /// Without this clamp, a very short programme inflated up to `minBlockWidth`
    /// would overlap the block that starts right after it. `nextStartX` is `nil`
    /// for the last programme in a row, which keeps its full `rawWidth`.
    static func blockWidth(rawWidth: CGFloat, startX: CGFloat, nextStartX: CGFloat?) -> CGFloat {
        guard let nextStartX else {
            return rawWidth
        }
        let available = max(1, nextStartX - startX)
        return min(rawWidth, available)
    }

    /// Filters `programmes` (assumed sorted ascending by `startTime`) down to
    /// those whose air time intersects `range`, padded by `overscan` on each
    /// side so blocks just outside the viewport are still drawn while scrolling.
    ///
    /// A programme intersects when it ends after the (padded) lower bound and
    /// starts before the (padded) upper bound.
    static func visibleProgrammes(
        in programmes: [TVListingsProgrammeItem],
        range: ClosedRange<Date>,
        overscan: TimeInterval = 0
    ) -> [TVListingsProgrammeItem] {
        let lower = range.lowerBound.addingTimeInterval(-overscan)
        let upper = range.upperBound.addingTimeInterval(overscan)

        return programmes.filter { item in
            item.programme.endTime > lower && item.programme.startTime < upper
        }
    }

}
