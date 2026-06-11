//
//  TimeHeader.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

/// The horizontal time ruler at the top of the grid. Decorative (the times are
/// also conveyed per-block), so the whole ruler is hidden from accessibility.
struct TimeHeader: View {

    let geometry: TimelineGeometry
    let boundaries: [Date]
    let contentWidth: CGFloat

    var body: some View {
        ZStack(alignment: .topLeading) {
            ForEach(boundaries, id: \.self) { boundary in
                Text(Self.label(for: boundary, timeZone: geometry.timeZone))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(width: slotWidth, alignment: .leading)
                    .offset(x: geometry.x(for: boundary))
            }
        }
        .frame(width: max(contentWidth, 1), height: EPGMetrics.headerHeight, alignment: .leading)
        .accessibilityHidden(true)
    }

    private var slotWidth: CGFloat {
        CGFloat(geometry.slotMinutes) * geometry.pixelsPerMinute
    }

    /// `HH:mm` in the geometry's time zone (Europe/London).
    static func label(for date: Date, timeZone: TimeZone) -> String {
        date.formatted(
            Date.FormatStyle(date: .omitted, time: .shortened, timeZone: timeZone)
                .hour(.twoDigits(amPM: .omitted))
                .minute(.twoDigits)
        )
    }

}
