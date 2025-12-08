//
//  TVRootFeature.swift
//  Popcorn
//
//  Created by Adam Young on 18/11/2025.
//

import ComposableArchitecture
import Foundation
import TVSeriesDetailsFeature
import TrendingTVSeriesFeature

@Reducer
struct TVRootFeature {

    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var trending = TrendingTVSeriesFeature.State()
    }

    @Reducer
    enum Path {
        case details(TVSeriesDetailsFeature)
    }

    enum Action {
        case trending(TrendingTVSeriesFeature.Action)
        case path(StackActionOf<Path>)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.trending, action: \.trending) {
            TrendingTVSeriesFeature()
        }

        Reduce { state, action in
            switch action {
            case .trending(.navigate(.tvSeriesDetails(let id))):
                state.path.append(.details(TVSeriesDetailsFeature.State(id: id)))
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }

}
