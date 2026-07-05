//
//  FeatureFlagsDependencies+Live.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
#if DEBUG
    import DeveloperFeature
#endif
import FeatureAccess

#if DEBUG
    extension FeatureFlagsDependencies {

        /// Builds the production dependencies from the app's shared services.
        ///
        /// Reads and mutates the shared feature-flag override service, mapping
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
#endif
