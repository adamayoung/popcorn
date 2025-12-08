//
//  TVApplicationFactory+TCA.swift
//  PopcornTVAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import Foundation
import PopcornConfigurationAdapters
import TMDbAdapters
import TVApplication

extension DependencyValues {

    var tvFactory: TVApplicationFactory {
        PopcornTVAdaptersFactory(
            tvSeriesService: self.tvSeriesService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration
        ).makeTVFactory()
    }

}
