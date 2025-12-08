//
//  ConfigurationLocalDataSource.swift
//  PopcornConfiguration
//
//  Created by Adam Young on 29/05/2025.
//

import CoreDomain
import Foundation

public protocol ConfigurationLocalDataSource: Actor, Sendable {

    func configuration() async -> AppConfiguration?

    func setConfiguration(_ appConfiguration: AppConfiguration) async

}
