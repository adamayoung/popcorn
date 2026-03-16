//
//  WatchProviderCollectionDetailsMapper.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

struct WatchProviderCollectionDetailsMapper {

    func map(
        _ collection: WatchProviderCollection,
        imagesConfiguration: ImagesConfiguration
    ) -> WatchProviderCollectionDetails {
        let providerMapper = WatchProviderDetailsMapper()

        return WatchProviderCollectionDetails(
            id: collection.id,
            link: collection.link,
            streamingProviders: collection.streamingProviders.map {
                providerMapper.map($0, imagesConfiguration: imagesConfiguration)
            },
            buyProviders: collection.buyProviders.map {
                providerMapper.map($0, imagesConfiguration: imagesConfiguration)
            },
            rentProviders: collection.rentProviders.map {
                providerMapper.map($0, imagesConfiguration: imagesConfiguration)
            },
            freeProviders: collection.freeProviders.map {
                providerMapper.map($0, imagesConfiguration: imagesConfiguration)
            }
        )
    }

}

private struct WatchProviderDetailsMapper {

    func map(
        _ provider: WatchProvider,
        imagesConfiguration: ImagesConfiguration
    ) -> WatchProviderDetails {
        WatchProviderDetails(
            id: provider.id,
            name: provider.name,
            logoURLSet: imagesConfiguration.logoURLSet(for: provider.logoPath)
        )
    }

}
