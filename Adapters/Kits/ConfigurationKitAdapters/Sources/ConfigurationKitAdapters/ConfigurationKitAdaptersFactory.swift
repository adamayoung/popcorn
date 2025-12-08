//
//  ConfigurationKitAdaptersFactory.swift
//  ConfigurationKitAdapters
//
//  Created by Adam Young on 26/11/2025.
//

import ConfigurationApplication
import Foundation
import TMDb

struct ConfigurationKitAdaptersFactory {

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
