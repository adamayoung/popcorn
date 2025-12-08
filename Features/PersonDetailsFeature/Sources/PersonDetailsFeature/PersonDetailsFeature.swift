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
    public struct State {
        var id: Int
        public let transitionID: String?
        var person: Person?
        var isLoading: Bool

        public init(
            id: Int,
            transitionID: String? = nil,
            person: Person? = nil,
            isLoading: Bool = false
        ) {
            self.id = id
            self.transitionID = transitionID
            self.person = person
            self.isLoading = isLoading
        }
    }

    public enum Action {
        case loadPerson
        case personLoaded(Person)
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadPerson:
                state.isLoading = true
                return handleFetchPerson(&state)

            case .personLoaded(let person):
                state.isLoading = false
                state.person = person
                return .none
            }
        }
    }

}

extension PersonDetailsFeature {

    fileprivate func handleFetchPerson(_ state: inout State) -> EffectOf<Self> {
        let id = state.id

        return .run { send in
            do {
                let movie = try await personDetails.fetch(id)
                await send(.personLoaded(movie))
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
