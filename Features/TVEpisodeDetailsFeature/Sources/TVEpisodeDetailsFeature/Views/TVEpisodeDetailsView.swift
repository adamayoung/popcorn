//
//  TVEpisodeDetailsView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

public struct TVEpisodeDetailsView: View {

    @Bindable private var store: StoreOf<TVEpisodeDetailsFeature>

    public init(store: StoreOf<TVEpisodeDetailsFeature>) {
        self._store = .init(store)
    }

    public var body: some View {
        ZStack {
            switch store.viewState {
            case .ready(let snapshot):
                content(
                    episode: snapshot.episode,
                    castMembers: snapshot.castMembers,
                    crewMembers: snapshot.crewMembers
                )

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
            store.send(.didAppear)
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
        episode: TVEpisode,
        castMembers: [CastMember],
        crewMembers: [CrewMember]
    ) -> some View {
        TVEpisodeDetailsContentView(
            episode: episode,
            castMembers: castMembers,
            crewMembers: crewMembers,
            didSelectCastAndCrew: {
                store.send(
                    .navigate(
                        .castAndCrew(
                            tvSeriesID: episode.tvSeriesID,
                            seasonNumber: episode.seasonNumber,
                            episodeNumber: episode.episodeNumber
                        )
                    )
                )
            },
            didSelectPerson: { personID in
                store.send(.navigate(.personDetails(id: personID)))
            }
        )
    }

}

#Preview("Ready") {
    NavigationStack {
        TVEpisodeDetailsView(
            store: Store(
                initialState: TVEpisodeDetailsFeature.State(
                    tvSeriesID: 1396,
                    seasonNumber: 1,
                    episodeNumber: 1,
                    viewState: .ready(
                        .init(
                            episode: TVEpisode.mock,
                            castMembers: CastMember.mocks,
                            crewMembers: CrewMember.mocks
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
        TVEpisodeDetailsView(
            store: Store(
                initialState: TVEpisodeDetailsFeature.State(
                    tvSeriesID: 1396,
                    seasonNumber: 1,
                    episodeNumber: 1,
                    viewState: .loading
                ),
                reducer: { EmptyReducer() }
            )
        )
    }
}

#Preview("Error") {
    NavigationStack {
        TVEpisodeDetailsView(
            store: Store(
                initialState: TVEpisodeDetailsFeature.State(
                    tvSeriesID: 1396,
                    seasonNumber: 1,
                    episodeNumber: 1,
                    viewState: .error(ViewStateError(FetchEpisodeDetailsError.notFound()))
                ),
                reducer: { EmptyReducer() }
            )
        )
    }
}
