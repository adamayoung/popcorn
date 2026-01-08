//
//  PopcornConfigurationFactory.swift
//  PopcornConfiguration
//
//  Created by Adam Young on 08/01/2026.
//

import ConfigurationApplication
import Foundation

public protocol PopcornConfigurationFactory: Sendable {

    func makeFetchAppConfigurationUseCase() -> FetchAppConfigurationUseCase

}
