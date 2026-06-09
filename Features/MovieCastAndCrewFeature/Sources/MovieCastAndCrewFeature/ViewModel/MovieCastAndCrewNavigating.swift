//
//  MovieCastAndCrewNavigating.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``MovieCastAndCrewViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into pushes / presentations. The MVVM replacement for
/// the former `MovieCastAndCrewFeature.Navigation` cases, which the parent reducer
/// intercepted.
@MainActor
public protocol MovieCastAndCrewNavigating {

    func openPersonDetails(id: Int, transitionID: String?)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpMovieCastAndCrewNavigator: MovieCastAndCrewNavigating {
        public init() {}
        public func openPersonDetails(id: Int, transitionID: String?) {}
    }
#endif
