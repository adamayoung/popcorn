//
//  DeveloperScreen.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// A pushed destination on the developer menu's navigation stack. The MVVM
/// replacement for `DeveloperFeature`'s `StackState<Path.State>` case.
enum DeveloperRoute: Hashable {
    case featureFlags
}

/// The MVVM developer menu, presented as a sheet from the app root (DEBUG only).
///
/// Hosts a static home list in a `NavigationStack` and pushes the feature-flags
/// screen. The MVVM replacement for the store-based `DeveloperView` +
/// `DeveloperFeature`. The App layer injects ``makeFeatureFlags`` so the screen
/// can build its child view model from the shared services without depending on
/// the composition layer.
public struct DeveloperScreen: View {

    @State private var viewModel: DeveloperViewModel
    @State private var path: [DeveloperRoute] = []
    @Environment(\.dismiss) private var dismiss

    private let makeFeatureFlags: () -> FeatureFlagsViewModel

    public init(
        viewModel: DeveloperViewModel = DeveloperViewModel(),
        makeFeatureFlags: @escaping () -> FeatureFlagsViewModel
    ) {
        _viewModel = State(initialValue: viewModel)
        self.makeFeatureFlags = makeFeatureFlags
    }

    public var body: some View {
        NavigationStack(path: $path) {
            List {
                NavigationLink(value: DeveloperRoute.featureFlags) {
                    Text("FEATURE_FLAGS", bundle: .module)
                }
            }
            .navigationTitle(Text("DEVELOPER", bundle: .module))
            .accessibilityIdentifier("developer.view")
            .navigationDestination(for: DeveloperRoute.self) { route in
                switch route {
                case .featureFlags:
                    FeatureFlagsScreen(viewModel: makeFeatureFlags())
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(role: .close) {
                        dismiss()
                    }
                }
            }
        }
    }

}

#if DEBUG
    #Preview {
        DeveloperScreen(
            makeFeatureFlags: {
                .preview(viewState: .ready(.init(featureFlags: FeatureFlag.mocks)))
            }
        )
    }
#endif
