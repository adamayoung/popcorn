//
//  TVEpisodeDetailsFeature.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import OSLog
import TCAFoundation

@Reducer
public struct TVEpisodeDetailsFeature: Sendable {

    private static let logger = Logger.tvEpisodeDetails

    @Dependency(\.tvEpisodeDetailsClient) private var client

    @ObservableState
    public struct State: Sendable, Equatable {
        public let tvSeriesID: Int
        public let seasonNumber: Int
        public let episodeNumber: Int
        public var episodeName: String
        public var viewState: ViewState<ViewSnapshot>

        public init(
            tvSeriesID: Int,
            seasonNumber: Int,
            episodeNumber: Int,
            episodeName: String,
            viewState: ViewState<ViewSnapshot> = .initial
        ) {
            self.tvSeriesID = tvSeriesID
            self.seasonNumber = seasonNumber
            self.episodeNumber = episodeNumber
            self.episodeName = episodeName
            self.viewState = viewState
        }
    }

    public struct ViewSnapshot: Equatable, Sendable {
        public let name: String
        public let overview: String?
        public let airDate: Date?
        public let stillURL: URL?

        public init(
            name: String,
            overview: String?,
            airDate: Date?,
            stillURL: URL?
        ) {
            self.name = name
            self.overview = overview
            self.airDate = airDate
            self.stillURL = stillURL
        }
    }

    public enum Action {
        case fetch
        case loaded(ViewSnapshot)
        case loadFailed(ViewStateError)
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
                state.episodeName = snapshot.name
                return .none

            case .loadFailed(let error):
                state.viewState = .error(error)
                return .none
            }
        }
    }

}

extension TVEpisodeDetailsFeature {

    private func handleFetch(_ state: inout State) -> EffectOf<Self> {
        .run { [state, client] send in
            Self.logger.info(
                "Fetching episode details [tvSeriesID: \(state.tvSeriesID, privacy: .private), S\(state.seasonNumber)E\(state.episodeNumber)]"
            )

            let episodeDetails: EpisodeDetails
            do {
                episodeDetails = try await client.fetchEpisodeDetails(
                    state.tvSeriesID,
                    state.seasonNumber,
                    state.episodeNumber
                )
            } catch {
                Self.logger.error(
                    "Failed fetching episode details [tvSeriesID: \(state.tvSeriesID, privacy: .private), S\(state.seasonNumber)E\(state.episodeNumber)]: \(error.localizedDescription, privacy: .public)"
                )
                await send(.loadFailed(ViewStateError(error)))
                return
            }

            let snapshot = ViewSnapshot(
                name: episodeDetails.name,
                overview: episodeDetails.overview,
                airDate: episodeDetails.airDate,
                stillURL: episodeDetails.stillURL
            )
            await send(.loaded(snapshot))
        }
    }

}
