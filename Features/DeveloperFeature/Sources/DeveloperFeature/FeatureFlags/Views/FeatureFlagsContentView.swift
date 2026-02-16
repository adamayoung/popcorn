//
//  FeatureFlagsContentView.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import SwiftUI

struct FeatureFlagsContentView: View {

    var featureFlags: [FeatureFlag]
    var updateFeatureValueOverride: (FeatureFlag, FeatureFlagOverrideState) -> Void

    var body: some View {
        Form {
            Section {
                ForEach(featureFlags) { featureFlag in
                    FeatureFlagRow(
                        featureFlag: featureFlag,
                        updateFeatureValueOverride: updateFeatureValueOverride
                    )
                }
            }
        }
    }

}

#Preview {
    NavigationStack {
        FeatureFlagsContentView(
            featureFlags: FeatureFlag.mocks,
            updateFeatureValueOverride: { _, _ in }
        )
    }
}
