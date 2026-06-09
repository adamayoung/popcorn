//
//  TrendingPeopleNavigating.swift
//  TrendingPeopleFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``TrendingPeopleViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into pushes / presentations. The MVVM replacement for
/// the former `TrendingPeopleFeature.Navigation` cases, which the parent reducer
/// intercepted.
@MainActor
public protocol TrendingPeopleNavigating {

    func openPersonDetails(id: Int)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpTrendingPeopleNavigator: TrendingPeopleNavigating {
        public init() {}
        public func openPersonDetails(id: Int) {}
    }
#endif
