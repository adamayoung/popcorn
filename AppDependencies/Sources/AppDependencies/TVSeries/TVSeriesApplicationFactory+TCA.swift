//
//  TVSeriesApplicationFactory+TCA.swift
//  AppDependencies
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import PopcornTVSeriesAdapters
import TVSeriesComposition

enum PopcornTVSeriesFactoryKey: DependencyKey {

    static var liveValue: PopcornTVSeriesFactory {
        @Dependency(\.tvSeriesService) var tvSeriesService
        @Dependency(\.fetchAppConfiguration) var fetchAppConfiguration
        return PopcornTVSeriesAdaptersFactory(
            tvSeriesService: tvSeriesService,
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
