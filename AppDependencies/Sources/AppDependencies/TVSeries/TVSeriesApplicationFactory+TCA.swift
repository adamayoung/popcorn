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

extension DependencyValues {

    var tvSeriesFactory: PopcornTVSeriesFactory {
        PopcornTVSeriesAdaptersFactory(
            tvSeriesService: tvSeriesService,
            fetchAppConfigurationUseCase: fetchAppConfiguration
        ).makeTVSeriesFactory()
    }

}
