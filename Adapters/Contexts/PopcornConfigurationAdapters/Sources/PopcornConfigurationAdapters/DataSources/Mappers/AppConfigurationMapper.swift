//
//  AppConfigurationMapper.swift
//  PopcornConfigurationAdapters
//
//  Created by Adam Young on 29/05/2025.
//

import ConfigurationDomain
import CoreDomain
import Foundation
import TMDb

struct AppConfigurationMapper {

    func map(_ tmdbAPIConfiguration: TMDb.APIConfiguration) -> AppConfiguration {
        AppConfiguration(
            images: map(tmdbAPIConfiguration.images)
        )
    }

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
