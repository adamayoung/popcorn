//
//  MovieCastAndCrewFeature.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import Observability
import OSLog
import TCAFoundation

@Reducer
public struct MovieCastAndCrewFeature: Sendable {

    private static let logger = Logger.movieCastAndCrew

    @Dependency(\.movieCastAndCrewClient) private var client
    @Dependency(\.observability) private var observability

    @ObservableState
    public struct State: Sendable {
        let movieID: Int
        public var viewState: ViewState<ViewSnapshot>

        public init(
            movieID: Int,
            viewState: ViewState<ViewSnapshot> = .initial
        ) {
            self.movieID = movieID
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

extension MovieCastAndCrewFeature {

    private func handleFetch(_ state: inout State) -> EffectOf<Self> {
        .run { [state, client] send in
            Self.logger.info(
                "Fetching cast and crew [movieID: \(state.movieID, privacy: .private)]"
            )

            let credits: Credits
            do {
                credits = try await client.fetchCredits(movieID: state.movieID)
            } catch {
                Self.logger.error(
                    "Failed fetching cast and crew [movieID: \(state.movieID, privacy: .private)]: \(error.localizedDescription, privacy: .public)"
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
