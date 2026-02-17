//
//  AppConfiguration.swift
//  CoreDomain
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public struct AppConfiguration: Sendable {

    public let images: ImagesConfiguration

    public init(images: ImagesConfiguration) {
        self.images = images
    }

}
