//
//  TrendingMoviesNavigating.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``TrendingMoviesViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into pushes / presentations. The MVVM replacement for
/// the former `TrendingMoviesFeature.Navigation` cases, which the parent reducer
/// intercepted.
@MainActor
public protocol TrendingMoviesNavigating {

    func openMovieDetails(id: Int)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpTrendingMoviesNavigator: TrendingMoviesNavigating {
        public init() {}
        public func openMovieDetails(id: Int) {}
    }
#endif
