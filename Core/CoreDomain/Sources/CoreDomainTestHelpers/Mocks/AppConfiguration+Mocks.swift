//
//  AppConfiguration+Mocks.swift
//  CoreDomain
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation

public extension AppConfiguration {

    ///
    /// Creates a mock app configuration for testing purposes.
    ///
    /// - Parameter images: The images configuration to use. Defaults to a mock configuration.
    ///
    /// - Returns: A mock ``AppConfiguration`` instance.
    ///
    static func mock(
        images: ImagesConfiguration = ImagesConfiguration.mock()
    ) -> AppConfiguration {
        AppConfiguration(
            images: images
        )
    }
}
