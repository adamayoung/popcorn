//
//  ExploreRootView.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import ExploreFeature
import MovieCastAndCrewFeature
import MovieDetailsFeature
import MovieIntelligenceFeature
import PersonDetailsFeature
import SwiftUI
import TVSeriesDetailsFeature
import TVSeriesIntelligenceFeature

struct ExploreRootView: View {

    @Bindable var store: StoreOf<ExploreRootFeature>
    @Namespace private var namespace

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ExploreView(
                store: store.scope(
                    state: \.explore,
                    action: \.explore
                ),
                transitionNamespace: namespace
            )
        } destination: { store in
            switch store.case {
            case .movieDetails(let store):
                movieDetails(store: store)
            case .tvSeriesDetails(let store):
                tvSeriesDetails(store: store)
            case .personDetails(let store):
                personDetails(store: store)
            case .movieCastAndCrew(let store):
                movieCastAndCrew(store: store)
            }
        }
        #if !os(macOS)
        .fullScreenCover(
            item: $store.scope(
                state: \.movieIntelligence,
                action: \.movieIntelligence
            )
        ) { store in
            MovieChatView(store: store)
        }
        .fullScreenCover(
            item: $store.scope(
                state: \.tvSeriesIntelligence,
                action: \.tvSeriesIntelligence
            )
        ) { store in
            TVSeriesChatView(store: store)
        }
        #else
        .sheet(
                    item: $store.scope(
                        state: \.movieIntelligence,
                        action: \.movieIntelligence
                    )
                ) { store in
                    MovieChatView(store: store)
                }
                .sheet(
                    item: $store.scope(
                        state: \.tvSeriesIntelligence,
                        action: \.tvSeriesIntelligence
                    )
                ) { store in
                    TVSeriesChatView(store: store)
                }
        #endif
    }

    @ViewBuilder
    private func movieDetails(store: StoreOf<MovieDetailsFeature>) -> some View {
        if let transitionID = store.transitionID {
            MovieDetailsView(store: store)
            #if os(iOS)
                .navigationTransition(.zoom(sourceID: transitionID, in: namespace))
            #endif
        } else {
            MovieDetailsView(store: store)
        }
    }

    @ViewBuilder
    private func tvSeriesDetails(store: StoreOf<TVSeriesDetailsFeature>) -> some View {
        if let transitionID = store.transitionID {
            TVSeriesDetailsView(
                store: store,
                transitionNamespace: namespace
            )
            #if os(iOS)
            .navigationTransition(.zoom(sourceID: transitionID, in: namespace))
            #endif
        } else {
            TVSeriesDetailsView(
                store: store,
                transitionNamespace: namespace
            )
        }
    }

    @ViewBuilder
    private func personDetails(store: StoreOf<PersonDetailsFeature>) -> some View {
        if let transitionID = store.transitionID {
            PersonDetailsView(
                store: store,
                transitionNamespace: namespace
            )
            #if os(iOS)
            .navigationTransition(.zoom(sourceID: transitionID, in: namespace))
            #endif
        } else {
            PersonDetailsView(
                store: store,
                transitionNamespace: namespace
            )
        }
    }

    private func movieCastAndCrew(store: StoreOf<MovieCastAndCrewFeature>) -> some View {
        MovieCastAndCrewView(
            store: store,
            transitionNamespace: namespace
        )
    }

}

#Preview {
    ExploreRootView(
        store: Store(
            initialState: ExploreRootFeature.State(),
            reducer: {
                ExploreRootFeature()
            }
        )
    )
}
