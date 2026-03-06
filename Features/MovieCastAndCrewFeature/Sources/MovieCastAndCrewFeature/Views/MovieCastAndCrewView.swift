//
//  MovieCastAndCrewView.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

public struct MovieCastAndCrewView: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Bindable private var store: StoreOf<MovieCastAndCrewFeature>
    private let namespace: Namespace.ID

    public init(
        store: StoreOf<MovieCastAndCrewFeature>,
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

extension MovieCastAndCrewView {

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension MovieCastAndCrewView {

    private func content(_ snapshot: MovieCastAndCrewFeature.ViewSnapshot) -> some View {
        MovieCastAndCrewContentView(
            castMembers: snapshot.castMembers,
            crewMembers: snapshot.crewMembers,
            crewByDepartment: snapshot.crewByDepartment,
            transitionNamespace: namespace
        ) { personID, transitionID in
            store.send(.navigate(.personDetails(id: personID, transitionID: transitionID)))
        }
    }

}

extension MovieCastAndCrewView {

    private func errorBody(_ error: ViewStateError) -> some View {
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
    }

}

#Preview("Ready") {
    @Previewable @Namespace var namespace

    NavigationStack {
        MovieCastAndCrewView(
            store: Store(
                initialState: MovieCastAndCrewFeature.State(
                    movieID: 1,
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
        MovieCastAndCrewView(
            store: Store(
                initialState: MovieCastAndCrewFeature.State(
                    movieID: 798_645,
                    viewState: .loading
                ),
                reducer: { EmptyReducer() }
            ),
            transitionNamespace: namespace
        )
    }
}
