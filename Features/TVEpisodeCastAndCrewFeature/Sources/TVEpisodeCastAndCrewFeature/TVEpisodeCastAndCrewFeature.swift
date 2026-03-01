//
//  TVEpisodeCastAndCrewFeature.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import OSLog
import TCAFoundation

@Reducer
public struct TVEpisodeCastAndCrewFeature: Sendable {

    private static let logger = Logger.tvEpisodeCastAndCrew

    @Dependency(\.tvEpisodeCastAndCrewClient) private var client

    @ObservableState
    public struct State: Equatable, Sendable {
        public let tvSeriesID: Int
        public let seasonNumber: Int
        public let episodeNumber: Int
        public var viewState: ViewState<ViewSnapshot>

        public init(
            tvSeriesID: Int,
            seasonNumber: Int,
            episodeNumber: Int,
            viewState: ViewState<ViewSnapshot> = .initial
        ) {
            self.tvSeriesID = tvSeriesID
            self.seasonNumber = seasonNumber
            self.episodeNumber = episodeNumber
            self.viewState = viewState
        }
    }

    public struct ViewSnapshot: Equatable, Sendable {
        public let castMembers: [CastMember]
        public let crewMembers: [CrewMember]
        public let crewByDepartment: [String: [CrewMember]]

        public init(
            castMembers: [CastMember],
            crewMembers: [CrewMember]
        ) {
            self.castMembers = castMembers
            self.crewMembers = crewMembers
            self.crewByDepartment = Dictionary(grouping: crewMembers, by: \.department)
        }
    }

    public enum Action {
        case fetch
        case loaded(ViewSnapshot)
        case loadFailed(ViewStateError)
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable, Sendable {
        case personDetails(id: Int, transitionID: String?)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetch:
                if case .ready = state.viewState {
                    return .none
                }
                if case .loading = state.viewState {
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

extension TVEpisodeCastAndCrewFeature {

    private func handleFetch(_ state: inout State) -> EffectOf<Self> {
        .run { [state, client] send in
            Self.logger.info(
                "Fetching episode cast and crew [tvSeriesID: \(state.tvSeriesID, privacy: .private), S\(state.seasonNumber)E\(state.episodeNumber)]"
            )

            let credits: Credits
            do {
                credits = try await client.fetchCredits(
                    tvSeriesID: state.tvSeriesID,
                    seasonNumber: state.seasonNumber,
                    episodeNumber: state.episodeNumber
                )
            } catch {
                Self.logger.error(
                    "Failed fetching episode cast and crew [tvSeriesID: \(state.tvSeriesID, privacy: .private), S\(state.seasonNumber)E\(state.episodeNumber)]: \(error.localizedDescription, privacy: .public)"
                )
                await send(.loadFailed(ViewStateError(error)))
                return
            }

            let viewSnapshot = ViewSnapshot(
                castMembers: credits.castMembers,
                crewMembers: credits.crewMembers
            )

            await send(.loaded(viewSnapshot))
        }
    }

}
