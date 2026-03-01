//
//  FetchTVEpisodeCreditsUseCase+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import TVSeriesApplication

enum FetchTVEpisodeCreditsUseCaseKey: DependencyKey {

    static var liveValue: any FetchTVEpisodeCreditsUseCase {
        @Dependency(\.tvSeriesFactory) var tvSeriesFactory
        return tvSeriesFactory.makeFetchTVEpisodeCreditsUseCase()
    }

}

public extension DependencyValues {

    var fetchTVEpisodeCredits: any FetchTVEpisodeCreditsUseCase {
        get { self[FetchTVEpisodeCreditsUseCaseKey.self] }
        set { self[FetchTVEpisodeCreditsUseCaseKey.self] = newValue }
    }

}
