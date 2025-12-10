//
//  PlotRemixGameFeature.swift
//  PlotRemixGameFeature
//
//  Created by Adam Young on 09/12/2025.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct PlotRemixGameFeature: Sendable {

    //    @Dependency(\.gamesCatalog) private var gamesCatalog: GamesCatalogClient

    @ObservableState
    public struct State {
        public init() {
        }
    }

    public enum Action {
        case loadGame
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadGame:
                return .none
            }
        }
    }

}
