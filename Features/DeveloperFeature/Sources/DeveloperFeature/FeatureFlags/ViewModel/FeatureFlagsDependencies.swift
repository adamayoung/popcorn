//
//  FeatureFlagsDependencies.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import FeatureAccess
import Foundation

/// The dependencies required by ``FeatureFlagsViewModel``.
///
/// A plain `Sendable` struct of closures — the MVVM replacement for the former
/// `FeatureFlagsClient` (`@DependencyClient`). Constructing it requires every
/// closure, so a missing dependency is a compile error. Build the production
/// instance with ``live(services:)``.
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

public extension FeatureFlagsDependencies {

    /// Builds the production dependencies from the app's shared services.
    ///
    /// Mirrors the former `FeatureFlagsClient.liveValue` exactly: it reads and
    /// mutates the shared feature-flag override service (the same instance the
    /// former `@Dependency(\.featureFlagsOverride)` resolved) and maps
    /// `FeatureAccess.FeatureFlag.allFlags` via ``FeatureFlagMapper`` with the
    /// service's actual and override values.
    static func live(services: AppServices) -> FeatureFlagsDependencies {
        let featureFlags = services.featureFlagsOverride

        return FeatureFlagsDependencies(
            fetchFeatureFlags: {
                let flags = FeatureAccess.FeatureFlag.allFlags
                let mapper = FeatureFlagMapper()
                return flags.map { flag in
                    let value = featureFlags.actualValue(for: flag)
                    let overrideValue = featureFlags.overrideValue(for: flag)
                    return mapper.map(flag, value: value, overrideValue: overrideValue)
                }
            },
            updateFeatureFlagValue: { flag, value in
                guard let featureFlag = FeatureAccess.FeatureFlag.flag(withID: flag.id) else {
                    return
                }

                guard let value else {
                    featureFlags.removeOverride(for: featureFlag)
                    return
                }

                featureFlags.setOverrideValue(value, for: featureFlag)
            },
            removeAllOverrides: {
                featureFlags.removeAllOverrides()
            }
        )
    }

}

#if DEBUG
    public extension FeatureFlagsDependencies {

        /// Mock dependencies for previews and snapshot tests (mirrors the former
        /// `FeatureFlagsClient.previewValue`).
        static var preview: FeatureFlagsDependencies {
            FeatureFlagsDependencies(
                fetchFeatureFlags: { FeatureFlag.mocks },
                updateFeatureFlagValue: { _, _ in },
                removeAllOverrides: {}
            )
        }

    }
#endif
