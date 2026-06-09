//
//  TVEpisodeCastAndCrewNavigating.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``TVEpisodeCastAndCrewViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into pushes / presentations. The MVVM replacement for
/// the former `TVEpisodeCastAndCrewFeature.Navigation` cases, which the parent
/// reducer intercepted.
@MainActor
public protocol TVEpisodeCastAndCrewNavigating {

    func openPersonDetails(id: Int, transitionID: String?)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpTVEpisodeCastAndCrewNavigator: TVEpisodeCastAndCrewNavigating {
        public init() {}
        public func openPersonDetails(id: Int, transitionID: String?) {}
    }
#endif
