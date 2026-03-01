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
                        .accessibilityLabel(Text("LOADING", bundle: .module))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .task {
                store.send(.fetch)
            }
    }

    private func content(snapshot: TVEpisodeCastAndCrewFeature.ViewSnapshot) -> some View {
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
        #if os(iOS)
        .listStyle(.insetGrouped)
        #endif
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
