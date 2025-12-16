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
        var gamesCatalog = GamesCatalogFeature.State()

        @Presents var plotRemixGame: PlotRemixGameFeature.State?
    }

    @Reducer
    enum Path {
        case plotRemix(PlotRemixGameFeature)
    }

    enum Action {
        case gamesCatalog(GamesCatalogFeature.Action)
        case plotRemixGame(PresentationAction<PlotRemixGameFeature.Action>)
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
                    state.plotRemixGame = .init(gameID: 1)
                    return .none

                default:
                    return .none
                }

            default:
                return .none
            }
        }
        .ifLet(\.$plotRemixGame, action: \.plotRemixGame) {
            PlotRemixGameFeature()
        }
    }

}
