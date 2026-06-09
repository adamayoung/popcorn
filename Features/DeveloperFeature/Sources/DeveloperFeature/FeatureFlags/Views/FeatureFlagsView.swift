//
//  FeatureFlagsView.swift
//  DeveloperFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The MVVM feature-flags screen, driven by ``FeatureFlagsViewModel``.
///
/// Renders the same store-free ``FeatureFlagsContentView`` and reproduces the
/// exact toolbar / loading / error chrome of the former `FeatureFlagsFeature`.
public struct FeatureFlagsView: View {

    @State private var viewModel: FeatureFlagsViewModel

    public init(viewModel: FeatureFlagsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .ready(let snapshot):
                content(snapshot)
            case .error(let error):
                errorBody(error)
            default:
                EmptyView()
            }
        }
        .accessibilityIdentifier("feature-flags.view")
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button(
                    LocalizedStringResource("RESET", bundle: .module),
                    role: .destructive
                ) {
                    Task { await viewModel.resetAllOverrides() }
                }
            }
        }
        .navigationTitle(Text("FEATURE_FLAGS", bundle: .module))
        .contentTransition(.opacity)
        .overlay {
            if viewModel.viewState.isLoading {
                loadingBody
            }
        }
        .task(id: viewModel.reloadID) {
            await viewModel.load()
        }
    }

}

extension FeatureFlagsView {

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func content(_ snapshot: FeatureFlagsViewModel.ViewSnapshot) -> some View {
        FeatureFlagsContentView(
            featureFlags: snapshot.featureFlags,
            updateFeatureValueOverride: { flag, override in
                Task { await viewModel.setFeatureFlagOverride(flag, override) }
            }
        )
    }

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentLoadErrorView(
            message: error.message,
            systemImage: "flag",
            reason: error.reason,
            isRetryable: error.isRetryable,
            retryAction: { viewModel.reload() }
        )
    }

}

#if DEBUG
    #Preview("Ready") {
        NavigationStack {
            FeatureFlagsView(
                viewModel: .preview(
                    viewState: .ready(.init(featureFlags: FeatureFlag.mocks))
                )
            )
        }
    }

    #Preview("Loading") {
        NavigationStack {
            FeatureFlagsView(viewModel: .preview(viewState: .loading))
        }
    }

    #Preview("Error") {
        NavigationStack {
            FeatureFlagsView(
                viewModel: .preview(
                    viewState: .error(ViewStateError(FetchFeatureFlagsError.unknown()))
                )
            )
        }
    }
#endif
