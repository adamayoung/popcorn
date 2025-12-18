//
//  AppConfigurationProviderAdapter.swift
//  PopcornTVSeriesAdapters
//
//  Created by Adam Young on 20/11/2025.
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
            span?.setData(error: error)
            span?.finish(status: .internalError)
            throw AppConfigurationProviderError(error)
        }

        span?.finish()

        return appConfiguration
    }

}

extension AppConfigurationProviderError {

    fileprivate init(_ error: Error) {
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
