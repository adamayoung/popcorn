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
        public var viewState: ViewState<ViewSnapshot>
        public var isCastAndCrewEnabled: Bool

        public init(
            tvSeriesID: Int,
            seasonNumber: Int,
            episodeNumber: Int,
            viewState: ViewState<ViewSnapshot> = .initial,
            isCastAndCrewEnabled: Bool = false
        ) {
            self.tvSeriesID = tvSeriesID
            self.seasonNumber = seasonNumber
            self.episodeNumber = episodeNumber
            self.viewState = viewState
            self.isCastAndCrewEnabled = isCastAndCrewEnabled
        }
    }

    public struct ViewSnapshot: Equatable, Sendable {
        public let episode: TVEpisode
        public let castMembers: [CastMember]
        public let crewMembers: [CrewMember]

        public init(
            episode: TVEpisode,
            castMembers: [CastMember] = [],
            crewMembers: [CrewMember] = []
        ) {
            self.episode = episode
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
                guard case .initial = state.viewState else {
                    return .none
                }
                return .run { send in
                    await send(.updateFeatureFlags)
                    await send(.fetch)
                }

            case .updateFeatureFlags:
                state.isCastAndCrewEnabled = (try? client.isCastAndCrewEnabled()) ?? false
                return .none

            case .fetch:
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

extension TVEpisodeDetailsFeature {

    private func handleFetch(_ state: inout State) -> EffectOf<Self> {
        .run { [state, client] send in
            Self.logger.info(
                "Fetching episode details [tvSeriesID: \(state.tvSeriesID, privacy: .private), S\(state.seasonNumber)E\(state.episodeNumber)]"
            )

            let isCastAndCrewEnabled = state.isCastAndCrewEnabled

            async let episodeTask = client.fetchEpisode(
                state.tvSeriesID,
                state.seasonNumber,
                state.episodeNumber
            )

            async let creditsTask: Credits? = {
                guard isCastAndCrewEnabled else {
                    return nil
                }
                return try? await client.fetchCredits(
                    state.tvSeriesID,
                    state.seasonNumber,
                    state.episodeNumber
                )
            }()

            let episode: TVEpisode
            do {
                episode = try await episodeTask
            } catch {
                _ = await creditsTask
                Self.logger.error(
                    "Failed fetching episode details [tvSeriesID: \(state.tvSeriesID, privacy: .private), S\(state.seasonNumber)E\(state.episodeNumber)]: \(error.localizedDescription, privacy: .public)"
                )
                await send(.loadFailed(ViewStateError(error)))
                return
            }

            let credits = await creditsTask
            if isCastAndCrewEnabled, credits == nil {
                Self.logger.warning(
                    "Failed fetching episode credits [tvSeriesID: \(state.tvSeriesID, privacy: .private), S\(state.seasonNumber)E\(state.episodeNumber)]"
                )
            }

            let snapshot = ViewSnapshot(
                episode: episode,
                castMembers: credits?.castMembers ?? [],
                crewMembers: credits?.crewMembers ?? []
            )
            await send(.loaded(snapshot))
        }
    }

}
