//
//  TVEpisodeDetailsPlaceholder.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture

@Reducer
struct TVEpisodeDetailsPlaceholder {

    @ObservableState
    struct State: Equatable {
        let tvSeriesID: Int
        let seasonNumber: Int
        let episodeNumber: Int
    }

    enum Action {}

    var body: some Reducer<State, Action> {
        EmptyReducer()
    }

}
