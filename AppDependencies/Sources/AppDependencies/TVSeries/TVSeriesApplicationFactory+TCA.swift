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
        @Dependency(\.tvEpisodeService) var tvEpisodeService
        @Dependency(\.fetchAppConfiguration) var fetchAppConfiguration
        @Dependency(\.themeColorProvider) var themeColorProvider
        return PopcornTVSeriesAdaptersFactory(
            tvSeriesService: tvSeriesService,
            tvSeasonService: tvSeasonService,
            tvEpisodeService: tvEpisodeService,
            fetchAppConfigurationUseCase: fetchAppConfiguration,
            themeColorProvider: themeColorProvider
        ).makeTVSeriesFactory()
    }

}

extension DependencyValues {

    var tvSeriesFactory: PopcornTVSeriesFactory {
        get { self[PopcornTVSeriesFactoryKey.self] }
        set { self[PopcornTVSeriesFactoryKey.self] = newValue }
    }

}
