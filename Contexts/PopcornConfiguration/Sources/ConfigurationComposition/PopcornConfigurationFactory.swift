//
//  PopcornConfigurationFactory.swift
//  PopcornConfiguration
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationApplication
import Foundation

public protocol PopcornConfigurationFactory: Sendable {

    func makeFetchAppConfigurationUseCase() -> FetchAppConfigurationUseCase

}
