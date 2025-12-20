//
//  ExploreRootView.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import ExploreFeature
import MovieDetailsFeature
import PersonDetailsFeature
import SwiftUI
import TVSeriesDetailsFeature

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
            }
        }
    }

    @ViewBuilder
    private func movieDetails(store: StoreOf<MovieDetailsFeature>) -> some View {
        if let transitionID = store.transitionID {
            MovieDetailsView(
                store: store,
                transitionNamespace: namespace
            )
            #if os(iOS)
            .navigationTransition(.zoom(sourceID: transitionID, in: namespace))
            #endif
        } else {
            MovieDetailsView(
                store: store,
                transitionNamespace: namespace
            )
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
