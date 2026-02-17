//
//  MockFetchAppConfigurationUseCase.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import CoreDomain
import Foundation

final class MockFetchAppConfigurationUseCase: FetchAppConfigurationUseCase, @unchecked Sendable {

    var executeCallCount = 0
    var executeStub: Result<AppConfiguration, FetchAppConfigurationError>?

    func execute() async throws(FetchAppConfigurationError) -> AppConfiguration {
        executeCallCount += 1

        guard let stub = executeStub else {
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
