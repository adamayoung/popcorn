//
//  DefaultFetchAppConfigurationUseCase.swift
//  ConfigurationKit
//
//  Created by Adam Young on 06/06/2025.
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
        let appConfiguration: AppConfiguration
        do {
            appConfiguration = try await repository.configuration()
        } catch let error {
            throw FetchAppConfigurationError(error)
        }

        return appConfiguration
    }

}
