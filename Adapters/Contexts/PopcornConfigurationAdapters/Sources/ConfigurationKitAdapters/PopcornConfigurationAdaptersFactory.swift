//
//  PopcornConfigurationAdaptersFactory.swift
//  PopcornConfigurationAdapters
//
//  Created by Adam Young on 26/11/2025.
//

import ConfigurationApplication
import Foundation
import TMDb

struct PopcornConfigurationAdaptersFactory {

    let configurationService: any ConfigurationService

    func makeConfigurationFactory() -> ConfigurationApplicationFactory {
        let configurationRemoteDataSource = TMDbConfigurationRemoteDataSource(
            configurationService: configurationService
        )

        return ConfigurationComposition.makeConfigurationFactory(
            configurationRemoteDataSource: configurationRemoteDataSource
        )
    }

}
