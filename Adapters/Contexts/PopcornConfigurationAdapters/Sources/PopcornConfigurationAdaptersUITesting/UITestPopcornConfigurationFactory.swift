//
//  UITestPopcornConfigurationFactory.swift
//  PopcornConfigurationAdapters
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationApplication
import ConfigurationComposition
import ConfigurationDomain
import Foundation

public final class UITestPopcornConfigurationFactory: PopcornConfigurationFactory {

    private let applicationFactory: ConfigurationApplicationFactory

    public init() {
        self.applicationFactory = ConfigurationApplicationFactory(
            configurationRepository: StubConfigurationRepository()
        )
    }

    public func makeFetchAppConfigurationUseCase() -> FetchAppConfigurationUseCase {
        applicationFactory.makeFetchAppConfigurationUseCase()
    }

}
