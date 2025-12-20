//
//  AppConfiguration.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public struct AppConfiguration: Sendable {

    public let images: ImagesConfiguration

    public init(images: ImagesConfiguration) {
        self.images = images
    }

}
