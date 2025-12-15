//
//  PopcornConfigurationAdaptersFactory.swift
//  PopcornConfigurationAdapters
//
//  Created by Adam Young on 26/11/2025.
//

import ConfigurationComposition
import Foundation
import TMDb

struct PopcornConfigurationAdaptersFactory {

    let configurationService: any ConfigurationService

    func makeConfigurationFactory() -> PopcornConfigurationFactory {
        let configurationRemoteDataSource = TMDbConfigurationRemoteDataSource(
            configurationService: configurationService
        )

        return PopcornConfigurationFactory(
            configurationRemoteDataSource: configurationRemoteDataSource
        )
    }

}
