//
//  PeopleRootFeature.swift
//  Popcorn
//
//  Created by Adam Young on 19/11/2025.
//

import ComposableArchitecture
import Foundation
import PersonDetailsFeature
import TrendingPeopleFeature

@Reducer
struct PeopleRootFeature {

    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var trending = TrendingPeopleFeature.State()
    }

    @Reducer
    enum Path {
        case details(PersonDetailsFeature)
    }

    enum Action {
        case trending(TrendingPeopleFeature.Action)
        case path(StackActionOf<Path>)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.trending, action: \.trending) {
            TrendingPeopleFeature()
        }

        Reduce { state, action in
            switch action {
            case .trending(.navigate(.personDetails(let id))):
                state.path.append(.details(PersonDetailsFeature.State(id: id)))
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }

}
