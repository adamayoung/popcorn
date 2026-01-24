//
//  MovieCastAndCrewView.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

public struct MovieCastAndCrewView: View {

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
        .navigationTitle(Text("CAST_AND_CREW", bundle: .module))
        #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
        #endif
            .overlay {
                if store.viewState.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .task {
                store.send(.fetch)
            }
    }

    @ViewBuilder
    private func content(snapshot: MovieCastAndCrewFeature.ViewSnapshot) -> some View {
        List {
            if !snapshot.castMembers.isEmpty {
                CastSection(
                    castMembers: snapshot.castMembers,
                    transitionNamespace: namespace
                ) { personID, transitionID in
                    store.send(.navigate(.personDetails(id: personID, transitionID: transitionID)))
                }
            }

            if !snapshot.crewMembers.isEmpty {
                CrewSection(
                    crewByDepartment: snapshot.crewByDepartment,
                    transitionNamespace: namespace
                ) { personID, transitionID in
                    store.send(.navigate(.personDetails(id: personID, transitionID: transitionID)))
                }
            }
        }
        .listStyle(.insetGrouped)
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
