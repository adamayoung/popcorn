//
//  TrendingPeopleFeature.swift
//  TrendingPeopleFeature
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import OSLog

@Reducer
public struct TrendingPeopleFeature: Sendable {

    private static let logger = Logger.trendingPeople

    @Dependency(\.trendingPeople) private var trendingPeople

    @ObservableState
    public struct State {
        var people: [PersonPreview]

        public init(people: [PersonPreview] = []) {
            self.people = people
        }
    }

    public enum Action {
        case loadTrendingPeople
        case trendingPeopleLoaded([PersonPreview])
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable {
        case personDetails(id: Int)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadTrendingPeople:
                return handleFetchTrendingPeople()
            case .trendingPeopleLoaded(let people):
                state.people = people
                return .none
            case .navigate:
                return .none
            }
        }
    }

}

private extension TrendingPeopleFeature {

    func handleFetchTrendingPeople() -> EffectOf<Self> {
        .run { [trendingPeople] send in
            Self.logger.info("User fetching trending people")

            do {
                let people = try await trendingPeople.fetch()
                await send(.trendingPeopleLoaded(people))
            } catch let error {
                Self.logger.error(
                    "Failed fetching trending people: \(error.localizedDescription, privacy: .public)"
                )
            }
        }
    }

}
