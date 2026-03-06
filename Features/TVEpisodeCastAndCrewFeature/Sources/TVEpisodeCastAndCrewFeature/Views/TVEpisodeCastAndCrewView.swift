//
//  TVEpisodeCastAndCrewView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

public struct TVEpisodeCastAndCrewView: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Bindable private var store: StoreOf<TVEpisodeCastAndCrewFeature>
    private let namespace: Namespace.ID

    public init(
        store: StoreOf<TVEpisodeCastAndCrewFeature>,
        transitionNamespace: Namespace.ID
    ) {
        self._store = .init(store)
        self.namespace = transitionNamespace
    }

    public var body: some View {
        ZStack {
            switch store.viewState {
            case .ready(let snapshot):
                content(snapshot)
            case .error(let error):
                errorBody(error)
            default:
                EmptyView()
            }
        }
        .contentTransition(.opacity)
        .animation(reduceMotion ? nil : .easeInOut(duration: 1), value: store.viewState.isReady)
        .overlay {
            if store.viewState.isLoading {
                loadingBody
            }
        }
        .task {
            store.send(.fetch)
        }
    }

}

extension TVEpisodeCastAndCrewView {

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension TVEpisodeCastAndCrewView {

    private func content(_ snapshot: TVEpisodeCastAndCrewFeature.ViewSnapshot) -> some View {
        TVEpisodeCastAndCrewContentView(
            castMembers: snapshot.castMembers,
            crewMembers: snapshot.crewMembers,
            crewByDepartment: snapshot.crewByDepartment,
            transitionNamespace: namespace
        ) { personID, transitionID in
            store.send(.navigate(.personDetails(id: personID, transitionID: transitionID)))
        }
    }

}

extension TVEpisodeCastAndCrewView {

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentLoadErrorView(
            message: error.message,
            systemImage: "person.2",
            reason: error.reason,
            isRetryable: error.isRetryable,
            retryAction: { store.send(.fetch) }
        )
    }

}

#Preview("Ready") {
    @Previewable @Namespace var namespace

    NavigationStack {
        TVEpisodeCastAndCrewView(
            store: Store(
                initialState: TVEpisodeCastAndCrewFeature.State(
                    tvSeriesID: 1396,
                    seasonNumber: 1,
                    episodeNumber: 1,
                    viewState: .ready(
                        .init(
                            castMembers: CastMember.mocks,
                            crewMembers: CrewMember.mocks
                        )
                    )
                ),
                reducer: {
                    EmptyReducer()
                }
            ),
            transitionNamespace: namespace
        )
    }
}

#Preview("Loading") {
    @Previewable @Namespace var namespace

    NavigationStack {
        TVEpisodeCastAndCrewView(
            store: Store(
                initialState: TVEpisodeCastAndCrewFeature.State(
                    tvSeriesID: 1396,
                    seasonNumber: 1,
                    episodeNumber: 1,
                    viewState: .loading
                ),
                reducer: { EmptyReducer() }
            ),
            transitionNamespace: namespace
        )
    }
}

#Preview("Error") {
    @Previewable @Namespace var namespace

    NavigationStack {
        TVEpisodeCastAndCrewView(
            store: Store(
                initialState: TVEpisodeCastAndCrewFeature.State(
                    tvSeriesID: 1396,
                    seasonNumber: 1,
                    episodeNumber: 1,
                    viewState: .error(ViewStateError(FetchCreditsError.notFound()))
                ),
                reducer: { EmptyReducer() }
            ),
            transitionNamespace: namespace
        )
    }
}
