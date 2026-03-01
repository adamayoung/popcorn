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
        .navigationTitle(navigationTitle)
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
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

    private var navigationTitle: Text {
        Text(verbatim: store.episodeName)
    }

    private func content(
        snapshot: TVEpisodeDetailsFeature.ViewSnapshot
    ) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: .spacing16) {
                StillImage(url: snapshot.stillURL)
                    .aspectRatio(16.0 / 9.0, contentMode: .fit)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: .spacing12) {
                    if let airDate = snapshot.airDate {
                        AirDateText(date: airDate)
                            .textCase(.uppercase)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .accessibilityIdentifier("tv-episode-details.air-date")
                    }

                    if let overview = snapshot.overview, !overview.isEmpty {
                        Text(verbatim: overview)
                            .font(.body)
                            .accessibilityIdentifier("tv-episode-details.overview")
                    }
                }
                .padding(.horizontal)

                if !snapshot.castMembers.isEmpty || !snapshot.crewMembers.isEmpty {
                    castAndCrewCarousel(snapshot: snapshot)
                        .padding(.bottom)
                }
            }
        }
        .accessibilityIdentifier("tv-episode-details.view")
    }

    private func castAndCrewCarousel(
        snapshot: TVEpisodeDetailsFeature.ViewSnapshot
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            sectionHeader("CAST_AND_CREW") {
                store.send(
                    .navigate(
                        .castAndCrew(
                            tvSeriesID: store.tvSeriesID,
                            seasonNumber: store.seasonNumber,
                            episodeNumber: store.episodeNumber
                        )
                    )
                )
            }

            CastAndCrewCarousel(
                castMembers: snapshot.castMembers,
                crewMembers: snapshot.crewMembers,
                didSelectPerson: { personID in
                    store.send(.navigate(.personDetails(id: personID)))
                }
            )
        }
    }

    private func sectionHeader(
        _ key: LocalizedStringKey,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            HStack(spacing: 4) {
                Text(key, bundle: .module)
                    .font(.title2)
                    .fontWeight(.bold)

                Image(systemName: "chevron.right")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .accessibilityHidden(true)
            }
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
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
                    episodeName: "Pilot",
                    viewState: .ready(
                        .init(
                            name: "Pilot",
                            overview: "A high school chemistry teacher diagnosed with lung cancer.",
                            airDate: Date(timeIntervalSince1970: 1_200_528_000),
                            stillURL: URL(string: "https://image.tmdb.org/t/p/original/ydlY3iPfeOAvu8gVqrxPoMvzfBj.jpg")
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
                    episodeName: "Pilot",
                    viewState: .loading
                ),
                reducer: { EmptyReducer() }
            )
        )
    }
}
