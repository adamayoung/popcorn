//
//  TVListingsRootFeature.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TVListingsFeature

@Reducer
struct TVListingsRootFeature {

    @ObservableState
    struct State {
        var tvListings = TVListingsFeature.State()
    }

    enum Action {
        case tvListings(TVListingsFeature.Action)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.tvListings, action: \.tvListings) {
            TVListingsFeature()
        }
    }

}
