//
//  FetchAppConfigurationUseCase.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

///
/// A use case that fetches the application configuration.
///
/// Use this protocol to retrieve the current application configuration settings.
///
public protocol FetchAppConfigurationUseCase: Sendable {

    /// Executes the use case to fetch the application configuration.
    ///
    /// - Returns: The ``AppConfiguration`` for the application.
    /// - Throws: ``FetchAppConfigurationError`` if the fetch fails.
    func execute() async throws(FetchAppConfigurationError) -> AppConfiguration

}
