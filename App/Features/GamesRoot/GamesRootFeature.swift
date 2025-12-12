//
//  GamesRootFeature.swift
//  Popcorn
//
//  Created by Adam Young on 09/12/2025.
//

import ComposableArchitecture
import Foundation
import GamesCatalogFeature
import PlotRemixGameFeature

@Reducer
struct GamesRootFeature {

    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var gamesCatalog = GamesCatalogFeature.State()
    }

    @Reducer
    enum Path {
        case plotRemix(PlotRemixGameFeature)
    }

    enum Action {
        case gamesCatalog(GamesCatalogFeature.Action)
        case path(StackActionOf<Path>)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.gamesCatalog, action: \.gamesCatalog) {
            GamesCatalogFeature()
        }

        Reduce { state, action in
            switch action {
            case .gamesCatalog(.navigate(.game(let id))):
                switch id {
                case 1:
                    state.path.append(.plotRemix(PlotRemixGameFeature.State(gameID: id)))
                default:
                    return .none
                }

                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }

}
