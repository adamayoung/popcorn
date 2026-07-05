//
//  FeatureFlagsDependencies.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation

/// The dependencies required by ``FeatureFlagsViewModel``.
///
/// A plain `Sendable` struct of closures providing the data dependencies for
/// ``FeatureFlagsViewModel``. Constructing it requires every closure, so a
/// missing dependency is a compile error. The production instance is built by the app's
/// composition layer; use ``preview`` for previews and tests.
public struct FeatureFlagsDependencies: Sendable {

    public var fetchFeatureFlags: @Sendable () async throws -> [FeatureFlag]
    public var updateFeatureFlagValue: @Sendable (FeatureFlag, Bool?) -> Void
    public var removeAllOverrides: @Sendable () -> Void

    public init(
        fetchFeatureFlags: @escaping @Sendable () async throws -> [FeatureFlag],
        updateFeatureFlagValue: @escaping @Sendable (FeatureFlag, Bool?) -> Void,
        removeAllOverrides: @escaping @Sendable () -> Void
    ) {
        self.fetchFeatureFlags = fetchFeatureFlags
        self.updateFeatureFlagValue = updateFeatureFlagValue
        self.removeAllOverrides = removeAllOverrides
    }

}

#if DEBUG
    public extension FeatureFlagsDependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: FeatureFlagsDependencies {
            FeatureFlagsDependencies(
                fetchFeatureFlags: { FeatureFlag.mocks },
                updateFeatureFlagValue: { _, _ in },
                removeAllOverrides: {}
            )
        }

    }
#endif
