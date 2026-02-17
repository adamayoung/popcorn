//
//  FetchAppConfigurationUseCase.swift
//  PopcornConfiguration
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public protocol FetchAppConfigurationUseCase: Sendable {

    func execute() async throws(FetchAppConfigurationError) -> AppConfiguration

}
