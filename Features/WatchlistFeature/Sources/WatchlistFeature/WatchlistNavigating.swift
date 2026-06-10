//
//  WatchlistNavigating.swift
//  WatchlistFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``WatchlistViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into pushes / presentations.
@MainActor
public protocol WatchlistNavigating {

    func openMovieDetails(id: Int, transitionID: String?)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpWatchlistNavigator: WatchlistNavigating {
        public init() {}
        public func openMovieDetails(id: Int, transitionID: String?) {}
    }
#endif
