//
//  AppConfiguration+Mocks.swift
//  CoreDomain
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation

public extension AppConfiguration {

    static func mock(
        images: ImagesConfiguration = ImagesConfiguration.mock()
    ) -> AppConfiguration {
        AppConfiguration(
            images: images
        )
    }
}
