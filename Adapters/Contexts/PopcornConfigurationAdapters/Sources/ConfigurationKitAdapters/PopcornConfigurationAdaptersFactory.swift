//
//  PopcornConfigurationAdaptersFactory.swift
//  PopcornConfigurationAdapters
//
//  Created by Adam Young on 26/11/2025.
//

import ConfigurationComposition
import Foundation
import TMDb

public final class PopcornConfigurationAdaptersFactory {

    private let configurationService: any ConfigurationService

    public init(configurationService: some ConfigurationService) {
        self.configurationService = configurationService
    }

    public func makeConfigurationFactory() -> PopcornConfigurationFactory {
        let configurationRemoteDataSource = TMDbConfigurationRemoteDataSource(
            configurationService: configurationService
        )

        return PopcornConfigurationFactory(
            configurationRemoteDataSource: configurationRemoteDataSource
        )
    }

}
