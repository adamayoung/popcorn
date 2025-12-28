//
//  AppConfiguration.swift
//  CoreDomain
//
//  Copyright © 2025 Adam Young.
//

import Foundation

///
/// Configuration settings for the application.
///
/// Contains the configuration required to properly display and handle
/// images throughout the application.
///
public struct AppConfiguration: Sendable {

    /// The images configuration for building image URLs.
    public let images: ImagesConfiguration

    /// Creates a new app configuration.
    ///
    /// - Parameter images: The images configuration for building image URLs.
    public init(images: ImagesConfiguration) {
        self.images = images
    }

}
