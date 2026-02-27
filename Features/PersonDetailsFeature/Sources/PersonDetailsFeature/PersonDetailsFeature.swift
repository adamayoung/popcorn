//
//  PersonDetailsFeature.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import AppDependencies
import ComposableArchitecture
import Foundation
import OSLog
import TCAFoundation

@Reducer
public struct PersonDetailsFeature: Sendable {

    private static let logger = Logger.personDetails

    @Dependency(\.personDetailsClient) private var client

    @ObservableState
    public struct State: Sendable, Equatable {
        var personID: Int
        public let transitionID: String?
        public var viewState: ViewState<ViewSnapshot>
        var isFocalPointEnabled: Bool

        public init(
            personID: Int,
            transitionID: String? = nil,
            viewState: ViewState<ViewSnapshot> = .initial,
            isFocalPointEnabled: Bool = false
        ) {
            self.personID = personID
            self.transitionID = transitionID
            self.viewState = viewState
            self.isFocalPointEnabled = isFocalPointEnabled
        }
    }

    public struct ViewSnapshot: Equatable, Sendable {
        public let person: Person

        public init(person: Person) {
            self.person = person
        }
    }

    public enum Action {
        case didAppear
        case updateFeatureFlags
        case fetch
        case loaded(ViewSnapshot)
        case loadFailed(ViewStateError)
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
                state.isFocalPointEnabled = (try? client.isFocalPointEnabled()) ?? false
                return .none

            case .fetch:
                if state.viewState.isReady || state.viewState.isError {
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
        .run { [state, client] send in
            Self.logger.info(
                "User fetching person [personID: \"\(state.personID, privacy: .private)\"]"
            )

            let person: Person
            do {
                person = try await client.fetchPerson(state.personID)
            } catch {
                Self.logger.error(
                    "Failed fetching person details: [personID: \"\(state.personID, privacy: .private)\"] \(error.localizedDescription, privacy: .public)"
                )
                await send(.loadFailed(ViewStateError(error)))
                return
            }

            let snapshot = ViewSnapshot(person: person)
            await send(.loaded(snapshot))
        }
    }

}
