//
//  EPGMetrics.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import CoreGraphics
import Foundation
import Observation

/// Shared layout constants for the EPG grid so the channel column, time header,
/// and programme rows stay aligned.
enum EPGMetrics {

    /// The shared height of a single channel row (channel cell and its
    /// programme blocks).
    static let rowHeight: CGFloat = 64

    /// The width of the fixed left-hand channel column.
    static let channelColumnWidth: CGFloat = 96

    /// The height of the fixed top time-header ruler.
    static let headerHeight: CGFloat = 32

    /// Off-screen padding (seconds) applied when windowing programmes so blocks
    /// just outside the viewport are still drawn while scrolling.
    static let windowOverscanSeconds: TimeInterval = 30 * 60

}

/// Holds the live scroll offset of the EPG body so the non-scrolling time-header
/// and channel-column mirrors can follow it.
///
/// Written from the body's `onScrollGeometryChange` action (plain assignment, no
/// animation) and read by the mirrors via `.offset(...)`. `@Observable` so only
/// the offset-dependent views re-render.
@Observable
@MainActor
final class EPGScrollState {

    /// The body's content offset. Positive when scrolled down/right.
    var contentOffset: CGPoint = .zero

}
