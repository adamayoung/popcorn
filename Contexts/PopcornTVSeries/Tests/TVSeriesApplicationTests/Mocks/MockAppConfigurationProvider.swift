//
//  MockAppConfigurationProvider.swift
//  PopcornTVSeries
//
//  Created by Adam Young on 18/12/2025.
//

import CoreDomain
import Foundation
import TVSeriesDomain

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
