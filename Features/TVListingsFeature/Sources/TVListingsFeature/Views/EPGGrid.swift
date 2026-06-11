//
//  EPGGrid.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

/// The scrolling EPG grid.
///
/// Scroll architecture (the house pattern from the spike):
/// - The body is the **only** scroll view (`ScrollView([.horizontal, .vertical])`).
/// - Its offset is read with `onScrollGeometryChange` into an `@Observable`
///   ``EPGScrollState`` (plain assignment, no animation).
/// - The top ``TimeHeader`` and left ``ChannelColumn`` are non-scrolling mirrors,
///   driven by a **negative** offset of the body's content offset, `.clipped()`,
///   `.geometryGroup()`, and `.allowsHitTesting(false)`.
/// - The fixed top-left corner and the two mirrors are composed with a `Grid`.
/// - The NOW playhead lives in the body content overlay (content space) so it
///   rides the scroll.
/// - Horizontal windowing derives the visible date range from the body offset and
///   viewport width, passing it to each row so only visible blocks render.
/// - Auto-scroll positions the body near "now" once, after the content width is
///   known. ``disableAutoScroll`` pins the unscrolled frame for snapshot tests.
struct EPGGrid: View {

    let snapshot: TVListingsGridSnapshot
    var disableAutoScroll = false

    @State private var scrollState = EPGScrollState()
    @State private var scrollPosition = ScrollPosition()
    @State private var viewportWidth: CGFloat = 0
    @State private var didAutoScroll = false

    private var geometry: TimelineGeometry {
        snapshot.geometry
    }

    /// The far edge of the timeline: the latest programme end (falling back to
    /// `now` for an entirely empty grid).
    private var timelineEnd: Date {
        let latestEnd = snapshot.rows
            .flatMap(\.programmes)
            .map(\.programme.endTime)
            .max()
        return latestEnd ?? snapshot.now
    }

    private var contentWidth: CGFloat {
        geometry.totalWidth(end: timelineEnd)
    }

    private var boundaries: [Date] {
        geometry.slotBoundaries(until: timelineEnd)
    }

    /// The absolute-time range currently visible, used to window each row.
    private var visibleRange: ClosedRange<Date> {
        let width = viewportWidth > 0 ? viewportWidth : contentWidth
        return geometry.visibleRange(
            forContentOffsetX: scrollState.contentOffset.x,
            viewportWidth: width
        )
    }

    var body: some View {
        Grid(alignment: .topLeading, horizontalSpacing: 0, verticalSpacing: 0) {
            GridRow {
                corner
                header
            }
            GridRow {
                channelColumn
                bodyScrollView
            }
        }
    }

    // MARK: - Corner

    private var corner: some View {
        Rectangle()
            .fill(.background)
            .frame(width: EPGMetrics.channelColumnWidth, height: EPGMetrics.headerHeight)
    }

    // MARK: - Header mirror

    private var header: some View {
        TimeHeader(geometry: geometry, boundaries: boundaries, contentWidth: contentWidth)
            .frame(height: EPGMetrics.headerHeight, alignment: .leading)
            .offset(x: -scrollState.contentOffset.x)
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipped()
            .geometryGroup()
            .allowsHitTesting(false)
    }

    // MARK: - Channel column mirror

    private var channelColumn: some View {
        ChannelColumn(rows: snapshot.rows)
            .offset(y: -scrollState.contentOffset.y)
            .frame(width: EPGMetrics.channelColumnWidth, alignment: .top)
            .frame(maxHeight: .infinity, alignment: .top)
            .clipped()
            .geometryGroup()
            .allowsHitTesting(false)
    }

    // MARK: - Body (the only scroll view)

    private var bodyScrollView: some View {
        ScrollView([.horizontal, .vertical]) {
            LazyVStack(spacing: 0) {
                ForEach(snapshot.rows) { row in
                    EPGRow(
                        row: row,
                        geometry: geometry,
                        contentWidth: contentWidth,
                        visibleRange: visibleRange
                    )
                }
            }
            .overlay(alignment: .topLeading) {
                NowPlayhead(height: CGFloat(snapshot.rows.count) * EPGMetrics.rowHeight)
                    .offset(x: geometry.nowX(at: snapshot.now))
            }
        }
        // Pin short content (few channels) to the top instead of letting the
        // two-axis ScrollView vertically centre it; long content still scrolls.
        .defaultScrollAnchor(.topLeading)
        .scrollIndicators(.hidden)
        .scrollPosition($scrollPosition)
        .onScrollGeometryChange(for: CGPoint.self) { geometry in
            geometry.contentOffset
        } action: { _, offset in
            scrollState.contentOffset = offset
        }
        .onScrollGeometryChange(for: CGFloat.self) { geometry in
            geometry.containerSize.width
        } action: { _, width in
            viewportWidth = width
        }
        .onScrollGeometryChange(for: CGFloat.self) { geometry in
            geometry.contentSize.width
        } action: { _, width in
            autoScrollIfNeeded(contentWidth: width)
        }
    }

    // MARK: - Auto-scroll

    private func autoScrollIfNeeded(contentWidth: CGFloat) {
        guard !disableAutoScroll, !didAutoScroll, contentWidth > 0 else {
            return
        }
        didAutoScroll = true

        let nowX = geometry.nowX(at: snapshot.now)
        let viewport = viewportWidth > 0 ? viewportWidth : contentWidth
        let targetX = max(0, nowX - viewport / 3)
        scrollPosition.scrollTo(point: CGPoint(x: targetX, y: scrollState.contentOffset.y))
    }

}
