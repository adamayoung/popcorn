//
//  TVApplicationFactory+TCA.swift
//  AppDependencies
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import PopcornTVAdapters
import TVComposition

extension DependencyValues {

    var tvFactory: PopcornTVFactory {
        PopcornTVAdaptersFactory(
            tvSeriesService: self.tvSeriesService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration
        ).makeTVFactory()
    }

}
