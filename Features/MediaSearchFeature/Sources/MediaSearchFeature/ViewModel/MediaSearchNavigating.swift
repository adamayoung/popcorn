//
//  MediaSearchNavigating.swift
//  MediaSearchFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``MediaSearchViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into pushes. Genre selection is a no-op and has no
/// protocol requirement.
@MainActor
public protocol MediaSearchNavigating {

    func openMovieDetails(id: Int)
    func openTVSeriesDetails(id: Int)
    func openPersonDetails(id: Int)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpMediaSearchNavigator: MediaSearchNavigating {
        public init() {}
        public func openMovieDetails(id: Int) {}
        public func openTVSeriesDetails(id: Int) {}
        public func openPersonDetails(id: Int) {}
    }
#endif
