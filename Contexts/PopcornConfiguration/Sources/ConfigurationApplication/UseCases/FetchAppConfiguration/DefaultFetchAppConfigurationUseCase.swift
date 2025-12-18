//
//  DefaultFetchAppConfigurationUseCase.swift
//  PopcornConfiguration
//
//  Created by Adam Young on 06/06/2025.
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
            span?.setData(error: error)
            span?.finish(status: .internalError)
            throw FetchAppConfigurationError(error)
        }

        span?.finish()
        return appConfiguration
    }

}
