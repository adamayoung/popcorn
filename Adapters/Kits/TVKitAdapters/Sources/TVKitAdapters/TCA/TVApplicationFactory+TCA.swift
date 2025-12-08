//
//  TVApplicationFactory+TCA.swift
//  TVKitAdapters
//
//  Created by Adam Young on 25/11/2025.
//

import ComposableArchitecture
import ConfigurationKitAdapters
import Foundation
import TMDbAdapters
import TVApplication

extension DependencyValues {

    var tvFactory: TVApplicationFactory {
        TVKitAdaptersFactory(
            tvSeriesService: self.tvSeriesService,
            fetchAppConfigurationUseCase: self.fetchAppConfiguration
        ).makeTVFactory()
    }

}
