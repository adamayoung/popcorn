//
//  TVSeasonDetailsView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
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
                content(snapshot: snapshot)

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
        .navigationTitle(Text(verbatim: store.seasonName))
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
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
        snapshot: TVSeasonDetailsFeature.ViewSnapshot
    ) -> some View {
        TVSeasonDetailsContentView(
            overview: snapshot.overview,
            episodes: snapshot.episodes,
            didSelectEpisode: { episodeNumber, episodeName in
                store.send(
                    .navigate(
                        .episodeDetails(
                            tvSeriesID: store.tvSeriesID,
                            seasonNumber: store.seasonNumber,
                            episodeNumber: episodeNumber,
                            episodeName: episodeName
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
                    seasonName: "Season 1",
                    viewState: .ready(
                        .init(
                            overview: "The first season of Breaking Bad.",
                            episodes: TVEpisode.mocks
                        )
                    )
                ),
                reducer: { EmptyReducer() }
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
                    seasonName: "Season 1",
                    viewState: .loading
                ),
                reducer: { EmptyReducer() }
            )
        )
    }
}
