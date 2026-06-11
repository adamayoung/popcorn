//
//  EPGRow.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

/// One channel's row of programme blocks, laid out absolutely along the timeline
/// axis. Only the programmes intersecting `visibleRange` (plus a small overscan)
/// are rendered, so off-screen blocks cost nothing while scrolling.
struct EPGRow: View {

    let row: TVListingsChannelRow
    let geometry: TimelineGeometry
    let contentWidth: CGFloat
    let visibleRange: ClosedRange<Date>

    /// A programme placed on the timeline: its left edge and clamped width.
    private struct LaidOutProgramme: Identifiable {
        let item: TVListingsProgrammeItem
        let startX: CGFloat
        let width: CGFloat
        var id: String {
            item.id
        }
    }

    /// The visible programmes with their absolute x and a width clamped to the
    /// next programme's start (so `minBlockWidth` can't make short blocks
    /// overlap their neighbour). Neighbours are taken from the full sorted row,
    /// not just the visible window, so windowing never changes a block's width.
    private var laidOutProgrammes: [LaidOutProgramme] {
        let sorted = row.programmes
        let visibleIDs = Set(
            EPGLayout.visibleProgrammes(
                in: sorted,
                range: visibleRange,
                overscan: EPGMetrics.windowOverscanSeconds
            )
            .map(\.id)
        )

        return sorted.enumerated().compactMap { index, item -> LaidOutProgramme? in
            guard visibleIDs.contains(item.id) else {
                return nil
            }
            let startX = geometry.x(for: item.programme.startTime)
            let rawWidth = geometry.width(from: item.programme.startTime, to: item.programme.endTime)
            let nextStartX = index + 1 < sorted.count
                ? geometry.x(for: sorted[index + 1].programme.startTime)
                : nil
            let width = EPGLayout.blockWidth(rawWidth: rawWidth, startX: startX, nextStartX: nextStartX)
            return LaidOutProgramme(item: item, startX: startX, width: width)
        }
    }

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Transparent spacer fixes the row's width/height even when no blocks
            // are visible (or the channel has no programmes at all).
            Color.clear
                .frame(width: max(contentWidth, 1), height: EPGMetrics.rowHeight)

            ForEach(laidOutProgrammes) { laid in
                ProgrammeBlock(item: laid.item, geometry: geometry, width: laid.width)
                    .offset(x: laid.startX)
            }
        }
        .frame(width: max(contentWidth, 1), height: EPGMetrics.rowHeight, alignment: .topLeading)
    }

}
