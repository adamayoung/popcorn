//
//  TVSeasonDetailsFeature.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import OSLog
import TCAFoundation

@Reducer
public struct TVSeasonDetailsFeature: Sendable {

    private static let logger = Logger.tvSeasonDetails

    @Dependency(\.tvSeasonDetailsClient) private var client

    @ObservableState
    public struct State: Sendable, Equatable {
        public let tvSeriesID: Int
        public let seasonNumber: Int
        public let seasonName: String
        public var viewState: ViewState<ViewSnapshot>

        public init(
            tvSeriesID: Int,
            seasonNumber: Int,
            seasonName: String,
            viewState: ViewState<ViewSnapshot> = .initial
        ) {
            self.tvSeriesID = tvSeriesID
            self.seasonNumber = seasonNumber
            self.seasonName = seasonName
            self.viewState = viewState
        }
    }

    public struct ViewSnapshot: Equatable, Sendable {
        public let overview: String?
        public let episodes: [TVEpisode]

        public init(overview: String?, episodes: [TVEpisode]) {
            self.overview = overview
            self.episodes = episodes
        }
    }

    public enum Action {
        case fetch
        case loaded(ViewSnapshot)
        case loadFailed(ViewStateError)
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable, Sendable {
        case episodeDetails(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetch:
                if case .ready = state.viewState {
                    return .none
                }

                state.viewState = .loading
                return handleFetch(&state)

            case .loaded(let snapshot):
                state.viewState = .ready(snapshot)
                return .none

            case .loadFailed(let error):
                state.viewState = .error(error)
                return .none

            case .navigate:
                return .none
            }
        }
    }

}

extension TVSeasonDetailsFeature {

    private func handleFetch(_ state: inout State) -> EffectOf<Self> {
        .run { [state, client] send in
            Self.logger.info(
                "Fetching season details [tvSeriesID: \(state.tvSeriesID, privacy: .private), seasonNumber: \(state.seasonNumber)]"
            )

            let seasonDetails: SeasonDetails
            do {
                seasonDetails = try await client.fetchSeasonDetails(
                    state.tvSeriesID,
                    state.seasonNumber
                )
            } catch {
                Self.logger.error(
                    "Failed fetching season details [tvSeriesID: \(state.tvSeriesID, privacy: .private), seasonNumber: \(state.seasonNumber)]: \(error.localizedDescription, privacy: .public)"
                )
                await send(.loadFailed(ViewStateError(error)))
                return
            }

            let snapshot = ViewSnapshot(
                overview: seasonDetails.overview,
                episodes: seasonDetails.episodes
            )
            await send(.loaded(snapshot))
        }
    }

}
