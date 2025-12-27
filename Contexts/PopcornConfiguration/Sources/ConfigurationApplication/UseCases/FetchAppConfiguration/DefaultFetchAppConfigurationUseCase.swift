//
//  DefaultFetchAppConfigurationUseCase.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationDomain
import CoreDomain
import Foundation

final class DefaultFetchAppConfigurationUseCase: FetchAppConfigurationUseCase {

    private let repository: any ConfigurationRepository

    init(repository: some ConfigurationRepository) {
        self.repository = repository
    }

    func execute() async throws(FetchAppConfigurationError) -> AppConfiguration {
        do {
            return try await repository.configuration()
        } catch let error {
            throw FetchAppConfigurationError(error)
        }
    }

}
