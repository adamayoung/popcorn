//
//  AppConfigurationProviding.swift
//  PopcornTVSeries
//
//  Created by Adam Young on 20/11/2025.
//

import CoreDomain
import Foundation

public protocol AppConfigurationProviding: Sendable {

    func appConfiguration() async throws(AppConfigurationProviderError) -> AppConfiguration

}

public enum AppConfigurationProviderError: Error {

    case unauthorised
    case unknown(Error? = nil)

}
