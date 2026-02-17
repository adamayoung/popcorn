//
//  ConfigurationLocalDataSource.swift
//  PopcornConfiguration
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public protocol ConfigurationLocalDataSource: Actor, Sendable {

    func configuration() async -> AppConfiguration?

    func setConfiguration(_ appConfiguration: AppConfiguration) async

}
