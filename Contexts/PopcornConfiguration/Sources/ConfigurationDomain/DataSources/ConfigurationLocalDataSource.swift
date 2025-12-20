//
//  ConfigurationLocalDataSource.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

public protocol ConfigurationLocalDataSource: Actor, Sendable {

    func configuration() async -> AppConfiguration?

    func setConfiguration(_ appConfiguration: AppConfiguration) async

}
