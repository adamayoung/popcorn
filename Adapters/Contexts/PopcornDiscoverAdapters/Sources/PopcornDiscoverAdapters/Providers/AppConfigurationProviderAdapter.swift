//
//  AppConfigurationProviderAdapter.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import CoreDomain
import DiscoverDomain
import Foundation

public final class AppConfigurationProviderAdapter: AppConfigurationProviding {

    private let fetchUseCase: any FetchAppConfigurationUseCase

    public init(fetchUseCase: some FetchAppConfigurationUseCase) {
        self.fetchUseCase = fetchUseCase
    }

    public func appConfiguration() async throws(AppConfigurationProviderError) -> AppConfiguration {
        let appConfiguration: AppConfiguration
        do {
            appConfiguration = try await fetchUseCase.execute()
        } catch let error {
            throw AppConfigurationProviderError(error)
        }

        return appConfiguration
    }

}

private extension AppConfigurationProviderError {

    init(_ error: Error) {
        guard let error = error as? FetchAppConfigurationError else {
            self = .unknown(error)
            return
        }

        switch error {
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
