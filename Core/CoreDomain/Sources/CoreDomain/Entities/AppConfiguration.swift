//
//  AppConfiguration.swift
//  CoreDomain
//
//  Created by Adam Young on 10/06/2025.
//

import Foundation

public struct AppConfiguration: Sendable {

    public let images: ImagesConfiguration

    public init(images: ImagesConfiguration) {
        self.images = images
    }

}
