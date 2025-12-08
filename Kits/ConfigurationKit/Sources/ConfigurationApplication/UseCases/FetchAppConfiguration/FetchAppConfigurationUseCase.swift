//
//  FetchAppConfigurationUseCase.swift
//  ConfigurationKit
//
//  Created by Adam Young on 06/06/2025.
//

import CoreDomain
import Foundation

public protocol FetchAppConfigurationUseCase: Sendable {

    func execute() async throws(FetchAppConfigurationError) -> AppConfiguration

}
