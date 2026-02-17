//
//  MockAppConfigurationProvider.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import DiscoverDomain
import Foundation

final class MockAppConfigurationProvider: AppConfigurationProviding, @unchecked Sendable {

    var appConfigurationCallCount = 0
    var appConfigurationStub: Result<AppConfiguration, AppConfigurationProviderError>?

    func appConfiguration() async throws(AppConfigurationProviderError) -> AppConfiguration {
        appConfigurationCallCount += 1

        guard let stub = appConfigurationStub else {
            throw .unknown()
        }

        switch stub {
        case .success(let configuration):
            return configuration
        case .failure(let error):
            throw error
        }
    }

}
