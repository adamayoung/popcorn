//
//  MockAppConfigurationProvider.swift
//  PopcornTrending
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TrendingDomain

final class MockAppConfigurationProvider: AppConfigurationProviding, @unchecked Sendable {

    var appConfigurationCallCount = 0
    var appConfigurationStub: Result<AppConfiguration, AppConfigurationProviderError>?

    func appConfiguration() async throws(AppConfigurationProviderError) -> AppConfiguration {
        appConfigurationCallCount += 1

        guard let stub = appConfigurationStub else {
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
