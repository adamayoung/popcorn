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
        public var isCastAndCrewEnabled: Bool

        public init(
            tvSeriesID: Int,
            seasonNumber: Int,
            episodeNumber: Int,
            episodeName: String,
            viewState: ViewState<ViewSnapshot> = .initial,
            isCastAndCrewEnabled: Bool = false
        ) {
            self.tvSeriesID = tvSeriesID
            self.seasonNumber = seasonNumber
            self.episodeNumber = episodeNumber
            self.episodeName = episodeName
            self.viewState = viewState
            self.isCastAndCrewEnabled = isCastAndCrewEnabled
        }
    }

    public struct ViewSnapshot: Equatable, Sendable {
        public let name: String
        public let overview: String?
        public let airDate: Date?
        public let stillURL: URL?
        public let castMembers: [CastMember]
        public let crewMembers: [CrewMember]

        public init(
            name: String,
            overview: String?,
            airDate: Date?,
            stillURL: URL?,
            castMembers: [CastMember] = [],
            crewMembers: [CrewMember] = []
        ) {
            self.name = name
            self.overview = overview
            self.airDate = airDate
            self.stillURL = stillURL
            self.castMembers = castMembers
            self.crewMembers = crewMembers
        }
    }

    public enum Action {
        case didAppear
        case updateFeatureFlags
        case fetch
        case loaded(ViewSnapshot)
        case loadFailed(ViewStateError)
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable, Sendable {
        case castAndCrew(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int)
        case personDetails(id: Int)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                return .run { send in
                    await send(.updateFeatureFlags)
                }

            case .updateFeatureFlags:
                state.isCastAndCrewEnabled = (try? client.isCastAndCrewEnabled()) ?? false
                guard case .initial = state.viewState else {
                    return .none
                }
                return .send(.fetch)

            case .fetch:
                state.viewState = .loading
                return handleFetch(&state)

            case .loaded(let snapshot):
                state.viewState = .ready(snapshot)
                state.episodeName = snapshot.name
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

            let isCastAndCrewEnabled = (try? client.isCastAndCrewEnabled()) ?? false

            var castMembers: [CastMember] = []
            var crewMembers: [CrewMember] = []
            if isCastAndCrewEnabled {
                do {
                    let credits = try await client.fetchCredits(
                        state.tvSeriesID,
                        state.seasonNumber,
                        state.episodeNumber
                    )
                    castMembers = credits.castMembers
                    crewMembers = credits.crewMembers
                } catch {
                    Self.logger.warning(
                        "Failed fetching episode credits [tvSeriesID: \(state.tvSeriesID, privacy: .private), S\(state.seasonNumber)E\(state.episodeNumber)]: \(error.localizedDescription, privacy: .public)"
                    )
                }
            }

            let snapshot = ViewSnapshot(
                name: episodeDetails.name,
                overview: episodeDetails.overview,
                airDate: episodeDetails.airDate,
                stillURL: episodeDetails.stillURL,
                castMembers: castMembers,
                crewMembers: crewMembers
            )
            await send(.loaded(snapshot))
        }
    }

}
