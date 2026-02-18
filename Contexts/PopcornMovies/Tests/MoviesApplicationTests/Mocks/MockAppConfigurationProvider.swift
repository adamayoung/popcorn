//
//  MockAppConfigurationProvider.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

final class MockAppConfigurationProvider: AppConfigurationProviding, @unchecked Sendable {

    var appConfigurationCallCount = 0
    var appConfigurationStub: Result<AppConfiguration, AppConfigurationProviderError>?
    var appConfigurationStubs: [Result<AppConfiguration, AppConfigurationProviderError>] = []

    func appConfiguration() async throws(AppConfigurationProviderError) -> AppConfiguration {
        let index = appConfigurationCallCount
        appConfigurationCallCount += 1

        let stub: Result<AppConfiguration, AppConfigurationProviderError>
        if !appConfigurationStubs.isEmpty {
            stub = appConfigurationStubs[min(index, appConfigurationStubs.count - 1)]
        } else if let singleStub = appConfigurationStub {
            stub = singleStub
        } else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let configuration):
            return configuration
        case .failure(let error):
            throw error
        }
    }

}
