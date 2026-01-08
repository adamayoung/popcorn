//
//  MockConfigurationRemoteDataSource.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationDomain
import ConfigurationInfrastructure
import CoreDomain
import Foundation

final class MockConfigurationRemoteDataSource: ConfigurationRemoteDataSource, @unchecked Sendable {

    var configurationCallCount = 0
    var configurationStub: Result<AppConfiguration, ConfigurationRepositoryError>?

    func configuration() async throws(ConfigurationRepositoryError) -> AppConfiguration {
        configurationCallCount += 1

        guard let stub = configurationStub else {
            throw .unknown()
        }

        switch stub {
        case .success(let appConfiguration):
            return appConfiguration
        case .failure(let error):
            throw error
        }
    }

}
