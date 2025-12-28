//
//  AppConfigurationProviderAdapter.swift
//  PopcornPeopleAdapters
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import CoreDomain
import PeopleDomain

///
/// An adapter that provides application configuration for the People domain.
///
/// This adapter bridges the ``FetchAppConfigurationUseCase`` to the
/// ``AppConfigurationProviding`` protocol required by the People domain.
///
struct AppConfigurationProviderAdapter: AppConfigurationProviding {

    private let fetchUseCase: any FetchAppConfigurationUseCase

    ///
    /// Creates a new app configuration provider adapter.
    ///
    /// - Parameter fetchUseCase: The use case for fetching application configuration.
    ///
    init(fetchUseCase: some FetchAppConfigurationUseCase) {
        self.fetchUseCase = fetchUseCase
    }

    ///
    /// Retrieves the current application configuration.
    ///
    /// - Returns: The application configuration containing image URLs and other settings.
    ///
    /// - Throws: ``AppConfigurationProviderError`` if the configuration cannot be fetched.
    ///
    func appConfiguration() async throws(AppConfigurationProviderError) -> AppConfiguration {
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
