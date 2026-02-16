//
//  FeatureFlagRow.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import SwiftUI

struct FeatureFlagRow: View {

    @State private var override: FeatureFlagOverrideState

    var featureFlag: FeatureFlag
    var updateFeatureValueOverride: (FeatureFlag, FeatureFlagOverrideState) -> Void

    init(
        featureFlag: FeatureFlag,
        updateFeatureValueOverride: @escaping (FeatureFlag, FeatureFlagOverrideState) -> Void
    ) {
        self.featureFlag = featureFlag
        self.updateFeatureValueOverride = updateFeatureValueOverride
        self._override = .init(initialValue: featureFlag.override)
    }

    var body: some View {
        VStack(alignment: .trailing) {
            Picker(featureFlag.name, selection: $override) {
                Text("DEFAULT", bundle: .module)
                    .tag(FeatureFlagOverrideState.default)

                Text("ENABLED", bundle: .module)
                    .tag(FeatureFlagOverrideState.enabled)

                Text("DISABLED", bundle: .module)
                    .tag(FeatureFlagOverrideState.disabled)
            }

            Text(featureFlag.value ? "DEFAULT_ENABLED" : "DEFAULT_DISABLED", bundle: .module)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .onChange(of: override) { _, newValue in
            updateFeatureValueOverride(featureFlag, newValue)
        }
    }

}

#Preview {
    @Previewable @State var featureFlags = FeatureFlag.mocks

    NavigationStack {
        Form {
            ForEach(featureFlags) { featureFlag in
                FeatureFlagRow(
                    featureFlag: featureFlag,
                    updateFeatureValueOverride: { _, _ in }
                )
            }
        }
    }
}
