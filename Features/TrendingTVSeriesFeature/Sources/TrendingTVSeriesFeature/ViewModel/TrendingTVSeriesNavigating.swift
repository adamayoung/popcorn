//
//  TrendingTVSeriesNavigating.swift
//  TrendingTVSeriesFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``TrendingTVSeriesViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into pushes / presentations.
@MainActor
public protocol TrendingTVSeriesNavigating {

    func openTVSeriesDetails(id: Int)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpTrendingTVSeriesNavigator: TrendingTVSeriesNavigating {
        public init() {}
        public func openTVSeriesDetails(id: Int) {}
    }
#endif
