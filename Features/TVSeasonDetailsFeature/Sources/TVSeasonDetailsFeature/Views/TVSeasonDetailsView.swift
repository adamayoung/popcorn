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
                ContentUnavailableView {
                    Label(
                        LocalizedStringResource("UNABLE_TO_LOAD", bundle: .module),
                        systemImage: "exclamationmark.triangle"
                    )
                } description: {
                    Text(error.message)
                } actions: {
                    if error.isRetryable {
                        Button(LocalizedStringResource("RETRY", bundle: .module)) {
                            store.send(.fetch)
                        }
                        .buttonStyle(.bordered)
                    }
                }

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
