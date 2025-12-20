//
//  FetchAppConfigurationUseCase.swift
//  PopcornConfiguration
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

public protocol FetchAppConfigurationUseCase: Sendable {

    func execute() async throws(FetchAppConfigurationError) -> AppConfiguration

}
