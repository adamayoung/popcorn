//
//  TMDbConfigurationRemoteDataSource.swift
//  PopcornConfigurationAdapters
//
//  Created by Adam Young on 29/05/2025.
//

import ConfigurationDomain
import ConfigurationInfrastructure
import CoreDomain
import Foundation
import TMDb

final class TMDbConfigurationRemoteDataSource: ConfigurationRemoteDataSource {

    private let configurationService: any ConfigurationService

    init(configurationService: any ConfigurationService) {
        self.configurationService = configurationService
    }

    func configuration() async throws(ConfigurationRepositoryError) -> AppConfiguration {
        let tmdbAPIConfiguration: TMDb.APIConfiguration

        do {
            tmdbAPIConfiguration = try await configurationService.apiConfiguration()
        } catch let error {
            throw ConfigurationRepositoryError(error)
        }

        let mapper = AppConfigurationMapper()
        let appConfiguration = mapper.map(tmdbAPIConfiguration)

        return appConfiguration
    }

}

extension ConfigurationRepositoryError {

    fileprivate init(_ error: Error) {
        guard let error = error as? TMDbError else {
            self = .unknown(error)
            return
        }

        self.init(error)
    }

    fileprivate init(_ error: TMDbError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
