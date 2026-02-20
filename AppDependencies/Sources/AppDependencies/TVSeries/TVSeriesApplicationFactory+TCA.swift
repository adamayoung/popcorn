//
//  TVSeriesApplicationFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
import Foundation
import PopcornTVSeriesAdapters
import TVSeriesComposition

enum PopcornTVSeriesFactoryKey: DependencyKey {

    static var liveValue: PopcornTVSeriesFactory {
        @Dependency(\.tvSeriesService) var tvSeriesService
        @Dependency(\.tvSeasonService) var tvSeasonService
        @Dependency(\.fetchAppConfiguration) var fetchAppConfiguration
        return PopcornTVSeriesAdaptersFactory(
            tvSeriesService: tvSeriesService,
            tvSeasonService: tvSeasonService,
            fetchAppConfigurationUseCase: fetchAppConfiguration
        ).makeTVSeriesFactory()
    }

}

extension DependencyValues {

    var tvSeriesFactory: PopcornTVSeriesFactory {
        get { self[PopcornTVSeriesFactoryKey.self] }
        set { self[PopcornTVSeriesFactoryKey.self] = newValue }
    }

}
