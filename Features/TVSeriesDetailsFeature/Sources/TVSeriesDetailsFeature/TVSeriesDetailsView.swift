//
//  TVSeriesDetailsView.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The TV series details screen, driven by ``TVSeriesDetailsViewModel``.
///
/// Renders ``TVSeriesDetailsContentView`` with toolbar, loading, and error chrome.
public struct TVSeriesDetailsView: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: TVSeriesDetailsViewModel

    public init(viewModel: TVSeriesDetailsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .ready(let tvSeries):
                content(tvSeries)
            case .error(let error):
                errorBody(error)
            default:
                EmptyView()
            }
        }
        .accessibilityIdentifier("tv-series-details.view")
        .toolbar {
            if case .ready(let tvSeries) = viewModel.viewState, viewModel.isIntelligenceEnabled {
                ToolbarItem(placement: toolbarTrailingPlacement) {
                    Button(
                        LocalizedStringResource("INTELLIGENCE", bundle: .module),
                        systemImage: "apple.intelligence"
                    ) {
                        viewModel.openIntelligence(id: tvSeries.id)
                    }
                }
            }
        }
        .contentTransition(.opacity)
        .animation(reduceMotion ? nil : .easeInOut(duration: 1), value: viewModel.viewState.isReady)
        .overlay {
            if viewModel.viewState.isLoading {
                loadingBody
            }
        }
        .onAppear {
            viewModel.didAppear()
        }
        .task(id: viewModel.reloadID) {
            await viewModel.load()
        }
    }

}

extension TVSeriesDetailsView {

    private var toolbarTrailingPlacement: ToolbarItemPlacement {
        #if os(macOS)
            .automatic
        #else
            .primaryAction
        #endif
    }

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension TVSeriesDetailsView {

    private func content(_ tvSeries: TVSeries) -> some View {
        TVSeriesDetailsContentView(
            tvSeries: tvSeries,
            castAndCrewState: viewModel.castAndCrewState,
            isBackdropFocalPointEnabled: viewModel.isBackdropFocalPointEnabled,
            didSelectSeason: { seasonNumber in
                viewModel.selectSeason(seasonNumber: seasonNumber)
            },
            didSelectPerson: { personID in
                viewModel.selectPerson(id: personID)
            },
            navigateToCastAndCrew: { _ in
                viewModel.openCastAndCrew()
            }
        )
    }

}

extension TVSeriesDetailsView {

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentLoadErrorView(
            message: error.message,
            systemImage: "tv",
            reason: error.reason,
            isRetryable: error.isRetryable,
            retryAction: { viewModel.reload() }
        )
    }

}

#if DEBUG
    #Preview("Ready") {
        NavigationStack {
            TVSeriesDetailsView(
                viewModel: .preview(
                    viewState: .ready(.mock),
                    castAndCrewState: .ready(.mock),
                    isIntelligenceEnabled: true,
                    isBackdropFocalPointEnabled: true
                )
            )
        }
    }

    #Preview("Cast & Crew Loading") {
        NavigationStack {
            TVSeriesDetailsView(
                viewModel: .preview(
                    viewState: .ready(.mock),
                    castAndCrewState: .loading,
                    isBackdropFocalPointEnabled: true
                )
            )
        }
    }

    #Preview("Loading") {
        NavigationStack {
            TVSeriesDetailsView(viewModel: .preview(viewState: .loading))
        }
    }

    #Preview("Error") {
        NavigationStack {
            TVSeriesDetailsView(
                viewModel: .preview(viewState: .error(ViewStateError(FetchTVSeriesError.notFound())))
            )
        }
    }
#endif
