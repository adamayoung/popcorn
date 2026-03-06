//
//  TVSeasonDetailsView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

public struct TVSeasonDetailsView: View {

    @Bindable private var store: StoreOf<TVSeasonDetailsFeature>

    public init(store: StoreOf<TVSeasonDetailsFeature>) {
        self._store = .init(store)
    }

    public var body: some View {
        ZStack {
            switch store.viewState {
            case .ready(let snapshot):
                content(season: snapshot.season, episodes: snapshot.episodes)

            case .error(let error):
                errorBody(error)

            default:
                EmptyView()
            }
        }
        .overlay {
            if store.viewState.isLoading {
                ProgressView()
                    .accessibilityLabel(Text("LOADING", bundle: .module))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .task {
            store.send(.fetch)
        }
    }

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentLoadErrorView(
            message: error.message,
            systemImage: "tv",
            reason: error.reason,
            isRetryable: error.isRetryable,
            retryAction: { store.send(.fetch) }
        )
    }

    private func content(
        season: TVSeason,
        episodes: [TVEpisode]
    ) -> some View {
        TVSeasonDetailsContentView(
            season: season,
            episodes: episodes,
            didSelectEpisode: { episodeNumber in
                store.send(
                    .navigate(
                        .episodeDetails(
                            tvSeriesID: season.tvSeriesID,
                            seasonNumber: season.seasonNumber,
                            episodeNumber: episodeNumber
                        )
                    )
                )
            }
        )
    }

}

#Preview("Ready") {
    NavigationStack {
        TVSeasonDetailsView(
            store: Store(
                initialState: TVSeasonDetailsFeature.State(
                    tvSeriesID: 1396,
                    seasonNumber: 1,
                    viewState: .ready(
                        .init(
                            season: TVSeason.mock,
                            episodes: TVEpisode.mocks
                        )
                    )
                ),
                reducer: { EmptyReducer()
                }
            )
        )
    }
}

#Preview("Loading") {
    NavigationStack {
        TVSeasonDetailsView(
            store: Store(
                initialState: TVSeasonDetailsFeature.State(
                    tvSeriesID: 1396,
                    seasonNumber: 1,
                    viewState: .loading
                ),
                reducer: { EmptyReducer() }
            )
        )
    }
}

#Preview("Error") {
    NavigationStack {
        TVSeasonDetailsView(
            store: Store(
                initialState: TVSeasonDetailsFeature.State(
                    tvSeriesID: 1396,
                    seasonNumber: 1,
                    viewState: .error(ViewStateError(FetchSeasonDetailsError.notFound()))
                ),
                reducer: { EmptyReducer() }
            )
        )
    }
}
