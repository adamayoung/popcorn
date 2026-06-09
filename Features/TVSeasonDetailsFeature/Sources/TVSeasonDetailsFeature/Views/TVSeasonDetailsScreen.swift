//
//  TVSeasonDetailsScreen.swift
//  TVSeasonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import DesignSystem
import Presentation
import SwiftUI

/// The MVVM TV season details screen, driven by ``TVSeasonDetailsViewModel``.
///
/// Renders the same store-free ``TVSeasonDetailsContentView`` and reproduces the
/// exact loading / error chrome of the former `TVSeasonDetailsView`, so recorded
/// snapshots stay byte-identical.
public struct TVSeasonDetailsScreen: View {

    @State private var viewModel: TVSeasonDetailsViewModel

    public init(viewModel: TVSeasonDetailsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .ready(let snapshot):
                content(season: snapshot.season, episodes: snapshot.episodes)

            case .error(let error):
                errorBody(error)

            default:
                EmptyView()
            }
        }
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

extension TVSeasonDetailsScreen {

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension TVSeasonDetailsScreen {

    private func content(
        season: TVSeason,
        episodes: [TVEpisode]
    ) -> some View {
        TVSeasonDetailsContentView(
            season: season,
            episodes: episodes,
            didSelectEpisode: { episodeNumber in
                viewModel.selectEpisode(
                    tvSeriesID: season.tvSeriesID,
                    seasonNumber: season.seasonNumber,
                    episodeNumber: episodeNumber
                )
            }
        )
    }

}

extension TVSeasonDetailsScreen {

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
            TVSeasonDetailsScreen(
                viewModel: .preview(
                    viewState: .ready(
                        .init(
                            season: TVSeason.mock,
                            episodes: TVEpisode.mocks
                        )
                    )
                )
            )
        }
    }

    #Preview("Loading") {
        NavigationStack {
            TVSeasonDetailsScreen(viewModel: .preview(viewState: .loading))
        }
    }

    #Preview("Error") {
        NavigationStack {
            TVSeasonDetailsScreen(
                viewModel: .preview(viewState: .error(ViewStateError(FetchSeasonDetailsError.notFound())))
            )
        }
    }
#endif
