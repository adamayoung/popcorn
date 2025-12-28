//
//  AppConfigurationProviderAdapter.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import CoreDomain
import Foundation
import TrendingDomain

///
/// An adapter that provides app configuration for the trending domain.
///
/// Bridges the configuration application layer to the trending domain by wrapping
/// the ``FetchAppConfigurationUseCase``.
///
public final class AppConfigurationProviderAdapter: AppConfigurationProviding {

    private let fetchUseCase: any FetchAppConfigurationUseCase

    ///
    /// Creates an app configuration provider adapter.
    ///
    /// - Parameter fetchUseCase: The use case for fetching app configuration.
    ///
    public init(fetchUseCase: some FetchAppConfigurationUseCase) {
        self.fetchUseCase = fetchUseCase
    }

    ///
    /// Fetches the app configuration.
    ///
    /// - Returns: The current app configuration.
    /// - Throws: ``AppConfigurationProviderError`` if the configuration cannot be fetched.
    ///
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
