//
//  TVSeriesApplicationFactory+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import PopcornTVSeriesAdapters
import TVSeriesComposition

extension DependencyValues {

    var tvSeriesFactory: PopcornTVSeriesFactory {
        PopcornTVSeriesAdaptersFactory(
            tvSeriesService: self.tvSeriesService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration
        ).makeTVSeriesFactory()
    }

}
