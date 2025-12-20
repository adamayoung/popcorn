//
//  PersonDetailsFeature.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import Observability
import OSLog

@Reducer
public struct PersonDetailsFeature: Sendable {

    private static let logger = Logger.personDetails

    @Dependency(\.personDetails) private var personDetails
    @Dependency(\.observability) private var observability

    @ObservableState
    public struct State: Sendable {
        var personID: Int
        public let transitionID: String?
        public var viewState: ViewState

        public var isLoading: Bool {
            switch viewState {
            case .loading: true
            default: false
            }
        }

        public var isReady: Bool {
            switch viewState {
            case .ready: true
            default: false
            }
        }

        public init(
            personID: Int,
            transitionID: String? = nil,
            viewState: ViewState = .initial
        ) {
            self.personID = personID
            self.transitionID = transitionID
            self.viewState = viewState
        }
    }

    public enum ViewState: Sendable {
        case initial
        case loading
        case ready(ViewSnapshot)
        case error(Error)
    }

    public struct ViewSnapshot: Sendable {
        public let person: Person

        public init(person: Person) {
            self.person = person
        }
    }

    public enum Action {
        case fetch
        case loaded(ViewSnapshot)
        case loadFailed(Error)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetch:
                if state.isReady {
                    state.viewState = .loading
                }

                return handleFetchPerson(&state)

            case .loaded(let snapshot):
                state.viewState = .ready(snapshot)
                return .none

            case .loadFailed(let error):
                state.viewState = .error(error)
                return .none
            }
        }
    }

}

private extension PersonDetailsFeature {

    func handleFetchPerson(_ state: inout State) -> EffectOf<Self> {
        .run { [state] send in
            Self.logger.info(
                "User fetching person [personID: \"\(state.personID, privacy: .private)\"]")

            let transaction = observability.startTransaction(
                name: "FetchPerson",
                operation: .uiAction
            )
            transaction.setData(key: "person_id", value: state.personID)

            do {
                let person = try await personDetails.fetch(state.personID)
                let snapshot = ViewSnapshot(person: person)
                transaction.finish()
                await send(.loaded(snapshot))
            } catch {
                Self.logger.error(
                    "Failed fetching person details: [personID: \"\(state.personID, privacy: .private)\"] \(error.localizedDescription, privacy: .public)"
                )
                transaction.setData(error: error)
                transaction.finish(status: .internalError)
                await send(.loadFailed(error))
            }
        }
    }

}
