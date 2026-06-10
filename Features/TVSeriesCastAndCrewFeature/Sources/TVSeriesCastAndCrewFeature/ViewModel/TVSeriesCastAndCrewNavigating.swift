//
//  TVSeriesCastAndCrewNavigating.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``TVSeriesCastAndCrewViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into pushes and presentations.
@MainActor
public protocol TVSeriesCastAndCrewNavigating {

    func openPersonDetails(id: Int, transitionID: String?)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpTVSeriesCastAndCrewNavigator: TVSeriesCastAndCrewNavigating {
        public init() {}
        public func openPersonDetails(id: Int, transitionID: String?) {}
    }
#endif
