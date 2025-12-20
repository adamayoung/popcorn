//
//  AppConfigurationProviderAdapter.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import CoreDomain
import Observability
import TVSeriesDomain

public struct AppConfigurationProviderAdapter: AppConfigurationProviding {

    private let fetchUseCase: any FetchAppConfigurationUseCase

    public init(fetchUseCase: some FetchAppConfigurationUseCase) {
        self.fetchUseCase = fetchUseCase
    }

    public func appConfiguration() async throws(AppConfigurationProviderError) -> AppConfiguration {
        let span = SpanContext.startChild(
            operation: .providerGet,
            description: "Get App Configuration"
        )

        let appConfiguration: AppConfiguration
        do {
            appConfiguration = try await fetchUseCase.execute()
        } catch let error {
            let providerError = AppConfigurationProviderError(error)
            span?.setData(error: providerError)
            span?.finish(status: .internalError)
            throw providerError
        }

        span?.finish()

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
