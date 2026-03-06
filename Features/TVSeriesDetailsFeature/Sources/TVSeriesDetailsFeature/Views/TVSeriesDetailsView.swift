//
//  TVSeriesDetailsView.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import DesignSystem
import SwiftUI
import TCAFoundation

public struct TVSeriesDetailsView: View {

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Bindable private var store: StoreOf<TVSeriesDetailsFeature>

    public init(store: StoreOf<TVSeriesDetailsFeature>) {
        self._store = .init(store)
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
        .accessibilityIdentifier("tv-series-details.view")
        .toolbar {
            if case .ready(let snapshot) = store.viewState, store.isIntelligenceEnabled {
                ToolbarItem(placement: toolbarTrailingPlacement) {
                    Button(
                        LocalizedStringResource("INTELLIGENCE", bundle: .module),
                        systemImage: "apple.intelligence"
                    ) {
                        store.send(.navigate(.tvSeriesIntelligence(id: snapshot.tvSeries.id)))
                    }
                }
            }
        }
        .contentTransition(.opacity)
        .animation(reduceMotion ? nil : .easeInOut(duration: 1), value: store.viewState.isReady)
        .overlay {
            if store.viewState.isLoading {
                loadingBody
            }
        }
        .onAppear {
            store.send(.didAppear)
        }
        .task {
            store.send(.fetch)
        }
    }

}

extension TVSeriesDetailsView {

    private var toolbarTrailingPlacement: ToolbarItemPlacement {
        #if os(macOS)
            .automatic
        #else
            .primaryAction
        #endif
    }

    private var loadingBody: some View {
        ProgressView()
            .accessibilityLabel(Text("LOADING", bundle: .module))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

}

extension TVSeriesDetailsView {

    private func content(_ snapshot: TVSeriesDetailsFeature.ViewSnapshot) -> some View {
        TVSeriesDetailsContentView(
            tvSeries: snapshot.tvSeries,
            castMembers: snapshot.castMembers,
            crewMembers: snapshot.crewMembers,
            isBackdropFocalPointEnabled: store.isBackdropFocalPointEnabled,
            didSelectSeason: { seasonNumber in
                store.send(
                    .navigate(
                        .seasonDetails(
                            tvSeriesID: snapshot.tvSeries.id,
                            seasonNumber: seasonNumber
                        )
                    )
                )
            },
            didSelectPerson: { personID in
                store.send(.navigate(.personDetails(id: personID)))
            },
            navigateToCastAndCrew: { tvSeriesID in
                store.send(.navigate(.castAndCrew(tvSeriesID: tvSeriesID)))
            }
        )
    }

}

extension TVSeriesDetailsView {

    private func errorBody(_ error: ViewStateError) -> some View {
        ContentUnavailableView {
            Label(LocalizedStringResource("UNABLE_TO_LOAD", bundle: .module), systemImage: "exclamationmark.triangle")
        } description: {
            Text(error.message)
        } actions: {
            if error.isRetryable {
                Button {
                    store.send(.fetch)
                } label: {
                    Text("RETRY", bundle: .module)
                }
                .buttonStyle(.bordered)
            }
        }
    }

}

#Preview("Ready") {
    NavigationStack {
        TVSeriesDetailsView(
            store: Store(
                initialState: TVSeriesDetailsFeature.State(
                    tvSeriesID: 1,
                    viewState: .ready(
                        .init(
                            tvSeries: TVSeries.mock,
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
        TVSeriesDetailsView(
            store: Store(
                initialState: TVSeriesDetailsFeature.State(
                    tvSeriesID: 1,
                    viewState: .loading
                ),
                reducer: { EmptyReducer() }
            )
        )
    }
}

#Preview("Error") {
    NavigationStack {
        TVSeriesDetailsView(
            store: Store(
                initialState: TVSeriesDetailsFeature.State(
                    tvSeriesID: 1,
                    viewState: .error(ViewStateError(message: "Error loading TV series"))
                ),
                reducer: { EmptyReducer() }
            )
        )
    }
}
