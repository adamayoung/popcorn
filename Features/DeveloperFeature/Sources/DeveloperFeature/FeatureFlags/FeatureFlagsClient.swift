//
//  FeatureFlagsClient.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import FeatureAccess
import Foundation
import OSLog

@DependencyClient
struct FeatureFlagsClient: Sendable {

    var fetchFeatureFlags: @Sendable () async throws -> [FeatureFlag]
    var updateFeatureFlagValue: @Sendable (FeatureFlag, Bool?) -> Void

}

extension FeatureFlagsClient: DependencyKey {

    static var liveValue: FeatureFlagsClient {
        @Dependency(\.featureFlagsOverride) var featureFlags

        return FeatureFlagsClient(
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
            }
        )
    }

    static var previewValue: FeatureFlagsClient {
        FeatureFlagsClient(
            fetchFeatureFlags: { FeatureFlag.mocks },
            updateFeatureFlagValue: { _, _ in }
        )
    }

}

extension DependencyValues {

    var featureFlagsClient: FeatureFlagsClient {
        get {
            self[FeatureFlagsClient.self]
        }
        set {
            self[FeatureFlagsClient.self] = newValue
        }
    }

}
