//
//  MockConfigurationLocalDataSource.swift
//  PopcornConfiguration
//
//  Copyright © 2026 Adam Young.
//

import ConfigurationInfrastructure
import CoreDomain
import Foundation

actor MockConfigurationLocalDataSource: ConfigurationLocalDataSource {

    var configurationCallCount = 0
    nonisolated(unsafe) var configurationStub: AppConfiguration?

    func configuration() async -> AppConfiguration? {
        configurationCallCount += 1
        return configurationStub
    }

    var setConfigurationCallCount = 0
    var setConfigurationCalledWith: [AppConfiguration] = []

    func setConfiguration(_ appConfiguration: AppConfiguration) async {
        setConfigurationCallCount += 1
        setConfigurationCalledWith.append(appConfiguration)
    }

}
