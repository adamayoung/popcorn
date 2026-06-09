//
//  TVSeriesDetailsScreen.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The MVVM TV series details screen, driven by ``TVSeriesDetailsViewModel``.
///
/// Renders the same store-free ``TVSeriesDetailsContentView`` and reproduces the
/// exact toolbar / loading / error chrome of the former `TVSeriesDetailsView`, so
/// recorded snapshots stay byte-identical.
public struct TVSeriesDetailsScreen: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel: TVSeriesDetailsViewModel

    public init(viewModel: TVSeriesDetailsViewModel) {
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
        .accessibilityIdentifier("tv-series-details.view")
        .toolbar {
            if case .ready(let snapshot) = viewModel.viewState, viewModel.isIntelligenceEnabled {
                ToolbarItem(placement: toolbarTrailingPlacement) {
                    Button(
                        LocalizedStringResource("INTELLIGENCE", bundle: .module),
                        systemImage: "apple.intelligence"
                    ) {
                        viewModel.openIntelligence(id: snapshot.tvSeries.id)
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

extension TVSeriesDetailsScreen {

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

extension TVSeriesDetailsScreen {

    private func content(_ snapshot: TVSeriesDetailsViewSnapshot) -> some View {
        TVSeriesDetailsContentView(
            tvSeries: snapshot.tvSeries,
            castMembers: snapshot.castMembers,
            crewMembers: snapshot.crewMembers,
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

extension TVSeriesDetailsScreen {

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
            TVSeriesDetailsScreen(
                viewModel: .preview(
                    viewState: .ready(
                        .init(
                            tvSeries: TVSeries.mock,
                            castMembers: CastMember.mocks,
                            crewMembers: CrewMember.mocks
                        )
                    ),
                    isIntelligenceEnabled: true,
                    isBackdropFocalPointEnabled: true
                )
            )
        }
    }

    #Preview("Loading") {
        NavigationStack {
            TVSeriesDetailsScreen(viewModel: .preview(viewState: .loading))
        }
    }

    #Preview("Error") {
        NavigationStack {
            TVSeriesDetailsScreen(
                viewModel: .preview(viewState: .error(ViewStateError(FetchTVSeriesError.notFound())))
            )
        }
    }
#endif
