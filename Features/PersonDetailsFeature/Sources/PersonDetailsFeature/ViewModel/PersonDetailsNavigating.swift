//
//  PersonDetailsNavigating.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``PersonDetailsViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`).
///
/// Person details is a leaf screen with no onward navigation, so this protocol
/// has no requirements. It exists to keep a consistent injection point for the
/// coordinator and to match the pattern used across the other detail features.
@MainActor
public protocol PersonDetailsNavigating {}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpPersonDetailsNavigator: PersonDetailsNavigating {
        public init() {}
    }
#endif
