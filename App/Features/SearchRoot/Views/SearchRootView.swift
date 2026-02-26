//
//  SearchRootView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import MediaSearchFeature
import MovieDetailsFeature
import PersonDetailsFeature
import SwiftUI
import TVEpisodeDetailsFeature
import TVSeasonDetailsFeature
import TVSeriesCastAndCrewFeature
import TVSeriesDetailsFeature

struct SearchRootView: View {

    @Bindable var store: StoreOf<SearchRootFeature>
    @Namespace private var namespace

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            MediaSearchView(
                store: store.scope(
                    state: \.mediaSearch,
                    action: \.mediaSearch
                )
            )
        } destination: { store in
            switch store.case {
            case .movieDetails(let store):
                MovieDetailsView(store: store)
            case .tvSeriesDetails(let store):
                TVSeriesDetailsView(
                    store: store,
                    transitionNamespace: namespace
                )
            case .tvSeasonDetails(let store):
                tvSeasonDetails(store: store)
            case .tvEpisodeDetails(let store):
                tvEpisodeDetails(store: store)
            case .personDetails(let store):
                PersonDetailsView(
                    store: store,
                    transitionNamespace: namespace
                )
            case .tvSeriesCastAndCrew(let store):
                tvSeriesCastAndCrew(store: store)
            }
        }
    }

    private func tvSeasonDetails(store: StoreOf<TVSeasonDetailsFeature>) -> some View {
        TVSeasonDetailsView(store: store)
    }

    private func tvEpisodeDetails(store: StoreOf<TVEpisodeDetailsFeature>) -> some View {
        TVEpisodeDetailsView(store: store)
    }

    private func tvSeriesCastAndCrew(store: StoreOf<TVSeriesCastAndCrewFeature>) -> some View {
        TVSeriesCastAndCrewView(
            store: store,
            transitionNamespace: namespace
        )
    }

}

#Preview {
    SearchRootView(
        store: Store(
            initialState: SearchRootFeature.State(),
            reducer: {
                SearchRootFeature()
            }
        )
    )
}
