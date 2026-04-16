//
//  SearchRootFeatureTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import PersonDetailsFeature
@testable import Popcorn
import Testing
import TVEpisodeDetailsFeature
import TVSeasonDetailsFeature
import TVSeriesCastAndCrewFeature
import TVSeriesDetailsFeature

@MainActor
@Suite("SearchRootFeature Tests")
struct SearchRootFeatureTests {

    private typealias Feature = SearchRootFeature

    @Test("tvSeriesDetails navigate seasonDetails appends tvSeasonDetails to path")
    func tvSeriesDetailsNavigateSeasonDetailsAppendsToPath() {
        let store = Store(
            initialState: {
                var state = Feature.State()
                state.path.append(
                    .tvSeriesDetails(TVSeriesDetailsFeature.State(tvSeriesID: 66732))
                )
                return state
            }()
        ) {
            Feature()
        }

        store.send(.path(.element(
            id: 0,
            action: .tvSeriesDetails(
                .navigate(.seasonDetails(tvSeriesID: 66732, seasonNumber: 1))
            )
        )))

        guard case .tvSeasonDetails(let seasonState) = store.path.last else {
            Issue.record("Expected tvSeasonDetails as last path element")
            return
        }
        #expect(store.path.count == 2)
        #expect(seasonState.tvSeriesID == 66732)
        #expect(seasonState.seasonNumber == 1)
    }

    @Test("tvSeriesDetails navigate personDetails appends personDetails to path")
    func tvSeriesDetailsNavigatePersonDetailsAppendsToPath() {
        let store = Store(
            initialState: {
                var state = Feature.State()
                state.path.append(
                    .tvSeriesDetails(TVSeriesDetailsFeature.State(tvSeriesID: 66732))
                )
                return state
            }()
        ) {
            Feature()
        }

        store.send(.path(.element(
            id: 0,
            action: .tvSeriesDetails(
                .navigate(.personDetails(id: 17419))
            )
        )))

        guard case .personDetails = store.path.last else {
            Issue.record("Expected personDetails as last path element")
            return
        }
        #expect(store.path.count == 2)
    }

    @Test("tvSeasonDetails navigate episodeDetails appends tvEpisodeDetails to path")
    func tvSeasonDetailsNavigateEpisodeDetailsAppendsToPath() {
        let store = Store(
            initialState: {
                var state = Feature.State()
                state.path.append(
                    .tvSeasonDetails(
                        TVSeasonDetailsFeature.State(tvSeriesID: 1396, seasonNumber: 1)
                    )
                )
                return state
            }()
        ) {
            Feature()
        }

        store.send(.path(.element(
            id: 0,
            action: .tvSeasonDetails(
                .navigate(
                    .episodeDetails(tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1)
                )
            )
        )))

        guard case .tvEpisodeDetails(let episodeState) = store.path.last else {
            Issue.record("Expected tvEpisodeDetails as last path element")
            return
        }
        #expect(store.path.count == 2)
        #expect(episodeState.tvSeriesID == 1396)
        #expect(episodeState.seasonNumber == 1)
        #expect(episodeState.episodeNumber == 1)
    }

    @Test("tvSeriesDetails navigate castAndCrew appends tvSeriesCastAndCrew to path")
    func tvSeriesDetailsNavigateCastAndCrewAppendsToPath() {
        let store = Store(
            initialState: {
                var state = Feature.State()
                state.path.append(
                    .tvSeriesDetails(TVSeriesDetailsFeature.State(tvSeriesID: 66732))
                )
                return state
            }()
        ) {
            Feature()
        }

        store.send(.path(.element(
            id: 0,
            action: .tvSeriesDetails(
                .navigate(.castAndCrew(tvSeriesID: 66732))
            )
        )))

        guard case .tvSeriesCastAndCrew(let castAndCrewState) = store.path.last else {
            Issue.record("Expected tvSeriesCastAndCrew as last path element")
            return
        }
        #expect(store.path.count == 2)
        #expect(castAndCrewState.tvSeriesID == 66732)
    }

    @Test("tvSeriesCastAndCrew navigate personDetails appends personDetails to path")
    func tvSeriesCastAndCrewNavigatePersonDetailsAppendsToPath() {
        let store = Store(
            initialState: {
                var state = Feature.State()
                state.path.append(
                    .tvSeriesCastAndCrew(TVSeriesCastAndCrewFeature.State(tvSeriesID: 66732))
                )
                return state
            }()
        ) {
            Feature()
        }

        store.send(.path(.element(
            id: 0,
            action: .tvSeriesCastAndCrew(
                .navigate(.personDetails(id: 17419, transitionID: nil))
            )
        )))

        guard case .personDetails = store.path.last else {
            Issue.record("Expected personDetails as last path element")
            return
        }
        #expect(store.path.count == 2)
    }

}
