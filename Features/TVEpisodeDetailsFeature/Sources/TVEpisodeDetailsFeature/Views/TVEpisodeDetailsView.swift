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

    let store: StoreOf<TVEpisodeDetailsFeature>

    public init(store: StoreOf<TVEpisodeDetailsFeature>) {
        self.store = store
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

    private var navigationTitle: Text {
        Text(verbatim: store.episodeName)
    }

    private func content(
        snapshot: TVEpisodeDetailsFeature.ViewSnapshot
    ) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                StillImage(url: snapshot.stillURL)
                    .aspectRatio(16.0 / 9.0, contentMode: .fit)

                VStack(alignment: .leading, spacing: 12) {
                    if let airDate = snapshot.airDate {
                        Text(airDate, format: .dateTime.year().month(.wide).day())
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .accessibilityLabel(
                                Text(
                                    "AIR_DATE \(airDate.formatted(.dateTime.year().month(.wide).day()))",
                                    bundle: .module
                                )
                            )
                    }

                    if let overview = snapshot.overview, !overview.isEmpty {
                        Text(verbatim: overview)
                            .font(.body)
                    }
                }
                .padding(.horizontal)
            }
        }
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
