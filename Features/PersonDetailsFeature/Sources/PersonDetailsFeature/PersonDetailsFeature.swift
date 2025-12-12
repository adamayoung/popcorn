//
//  PersonDetailsFeature.swift
//  PersonDetailsFeature
//
//  Created by Adam Young on 17/11/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct PersonDetailsFeature: Sendable {

    @Dependency(\.personDetails) var personDetails: PersonDetailsClient

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

extension PersonDetailsFeature {

    fileprivate func handleFetchPerson(_ state: inout State) -> EffectOf<Self> {
        .run { [state] send in
            do {
                let person = try await personDetails.fetch(state.personID)
                let snapshot = ViewSnapshot(person: person)
                await send(.loaded(snapshot))
            } catch {
                await send(.loadFailed(error))
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
