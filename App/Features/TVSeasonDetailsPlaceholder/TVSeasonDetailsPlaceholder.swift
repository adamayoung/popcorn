//
//  TVSeasonDetailsPlaceholder.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation

@Reducer
struct TVSeasonDetailsPlaceholder {

    @ObservableState
    struct State: Equatable {
        let tvSeriesID: Int
        let seasonNumber: Int
    }

    enum Action {}

    var body: some Reducer<State, Action> {
        EmptyReducer()
    }

}
