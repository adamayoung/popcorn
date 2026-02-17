//
//  DefaultFetchAppConfigurationUseCase.swift
//  PopcornConfiguration
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationDomain
import CoreDomain
import Foundation
import Observability

final class DefaultFetchAppConfigurationUseCase: FetchAppConfigurationUseCase {

    private let repository: any ConfigurationRepository

    init(repository: some ConfigurationRepository) {
        self.repository = repository
    }

    func execute() async throws(FetchAppConfigurationError) -> AppConfiguration {
        let span = SpanContext.startChild(
            operation: .useCaseExecute,
            description: "FetchAppConfigurationUseCase.execute"
        )

        let appConfiguration: AppConfiguration
        do {
            appConfiguration = try await repository.configuration()
        } catch let error {
            let configurationError = FetchAppConfigurationError(error)
            span?.setData(error: configurationError)
            span?.finish(status: .internalError)
            throw configurationError
        }

        span?.finish()
        return appConfiguration
    }

}
