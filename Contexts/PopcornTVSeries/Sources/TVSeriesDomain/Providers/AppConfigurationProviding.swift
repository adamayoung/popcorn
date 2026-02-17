//
//  AppConfigurationProviding.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
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
