//
//  FetchTVEpisodeDetailsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TVSeriesApplication

enum FetchTVEpisodeDetailsUseCaseKey: DependencyKey {

    static var liveValue: any FetchTVEpisodeDetailsUseCase {
        @Dependency(\.tvSeriesFactory) var tvSeriesFactory
        return tvSeriesFactory.makeFetchTVEpisodeDetailsUseCase()
    }

}

public extension DependencyValues {

    var fetchTVEpisodeDetails: any FetchTVEpisodeDetailsUseCase {
        get { self[FetchTVEpisodeDetailsUseCaseKey.self] }
        set { self[FetchTVEpisodeDetailsUseCaseKey.self] = newValue }
    }

}
