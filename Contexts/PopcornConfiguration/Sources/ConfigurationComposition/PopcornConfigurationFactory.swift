//
//  PopcornConfigurationFactory.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import Foundation

public protocol PopcornConfigurationFactory: Sendable {

    func makeFetchAppConfigurationUseCase() -> FetchAppConfigurationUseCase

}
