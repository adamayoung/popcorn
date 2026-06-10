//
//  GamesCatalogNavigating.swift
//  GamesCatalogFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``GamesCatalogViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into presentations.
@MainActor
public protocol GamesCatalogNavigating {

    func openGame(id: Int)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpGamesCatalogNavigator: GamesCatalogNavigating {
        public init() {}
        public func openGame(id: Int) {}
    }
#endif
