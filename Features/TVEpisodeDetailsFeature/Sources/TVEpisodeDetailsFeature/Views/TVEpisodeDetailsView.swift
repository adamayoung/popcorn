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
            store.send(.didAppear)
        }
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
