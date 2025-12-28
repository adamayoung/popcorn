//
//  AppConfigurationMapper.swift
//  PopcornConfigurationAdapters
//
//  Copyright © 2025 Adam Young.
//

import ConfigurationDomain
import CoreDomain
import Foundation
import TMDb

///
/// Maps TMDb API configuration responses to domain ``AppConfiguration`` entities.
///
/// This mapper transforms TMDb-specific configuration objects into the
/// application's domain model, handling image URL generation and other
/// configuration settings.
///
struct AppConfigurationMapper {

    ///
    /// Maps a TMDb API configuration to an application configuration.
    ///
    /// - Parameter tmdbAPIConfiguration: The TMDb API configuration to map.
    ///
    /// - Returns: An ``AppConfiguration`` containing the mapped image configuration.
    ///
    func map(_ tmdbAPIConfiguration: TMDb.APIConfiguration) -> AppConfiguration {
        AppConfiguration(
            images: map(tmdbAPIConfiguration.images)
        )
    }

    ///
    /// Maps a TMDb images configuration to a domain images configuration.
    ///
    /// - Parameter tmdbImagesConfiguration: The TMDb images configuration to map.
    ///
    /// - Returns: An ``ImagesConfiguration`` with URL handlers for poster, backdrop, logo, and profile images.
    ///
    func map(
        _ tmdbImagesConfiguration: TMDb.ImagesConfiguration
    ) -> CoreDomain.ImagesConfiguration {
        ImagesConfiguration(
            posterURLHandler: { path, idealWidth in
                tmdbImagesConfiguration.posterURL(for: path, idealWidth: idealWidth)
            },
            backdropURLHandler: { path, idealWidth in
                tmdbImagesConfiguration.backdropURL(for: path, idealWidth: idealWidth)
            },
            logoURLHandler: { path, idealWidth in
                tmdbImagesConfiguration.logoURL(for: path, idealWidth: idealWidth)
            },
            profileURLHandler: { path, idealWidth in
                tmdbImagesConfiguration.profileURL(for: path, idealWidth: idealWidth)
            }
        )
    }

}
