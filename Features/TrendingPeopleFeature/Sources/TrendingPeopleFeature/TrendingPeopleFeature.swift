//
//  TrendingPeopleFeature.swift
//  TrendingPeopleFeature
//
//  Created by Adam Young on 19/11/2025.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import OSLog
import Observability

@Reducer
public struct TrendingPeopleFeature: Sendable {

    @Dependency(\.trendingPeople) private var trendingPeople
    @Dependency(\.observability) private var observability

    private static let logger = Logger(
        subsystem: "TrendingPeopleFeature",
        category: "TrendingPeopleFeatureReducer"
    )

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

extension TrendingPeopleFeature {

    fileprivate func handleFetchTrendingPeople() -> EffectOf<Self> {
        .run { send in
            let transaction = observability.startTransaction(
                name: "FetchTrendingPeople",
                operation: .uiAction
            )

            do {
                let people = try await trendingPeople.fetch()
                transaction.finish()
                await send(.trendingPeopleLoaded(people))
            } catch let error {
                transaction.setData(error: error)
                transaction.finish(status: .internalError)
                Self.logger.error("Failed fetching trending people: \(error.localizedDescription)")
            }
        }
    }

}
