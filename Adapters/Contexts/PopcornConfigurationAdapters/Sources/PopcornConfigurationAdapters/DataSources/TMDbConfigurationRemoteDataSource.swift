//
//  TMDbConfigurationRemoteDataSource.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationDomain
import ConfigurationInfrastructure
import CoreDomain
import Foundation
import Observability
import TMDb

final class TMDbConfigurationRemoteDataSource: ConfigurationRemoteDataSource {

    private let configurationService: any ConfigurationService

    init(configurationService: any ConfigurationService) {
        self.configurationService = configurationService
    }

    func configuration() async throws(ConfigurationRepositoryError) -> AppConfiguration {
        let span = SpanContext.startChild(
            operation: .remoteDataSourceGet,
            description: "Get AppConfiguration"
        )

        let tmdbAPIConfiguration: TMDb.APIConfiguration

        do {
            tmdbAPIConfiguration = try await configurationService.apiConfiguration()
        } catch let error {
            let repositoryError = ConfigurationRepositoryError(error)
            span?.setData(error: repositoryError)
            span?.finish(status: .internalError)
            throw repositoryError
        }

        let mapper = AppConfigurationMapper()
        let appConfiguration = mapper.map(tmdbAPIConfiguration)
        span?.finish()

        return appConfiguration
    }

}

private extension ConfigurationRepositoryError {

    init(_ error: Error) {
        guard let error = error as? TMDbError else {
            self = .unknown(error)
            return
        }

        self.init(error)
    }

    init(_ error: TMDbError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
