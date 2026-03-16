//
//  WatchProviderCollectionMapper.swift
//  PopcornMoviesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesDomain
import TMDb

struct WatchProviderCollectionMapper {

    private let watchProviderMapper = WatchProviderMapper()

    func map(movieID: Int, _ dto: TMDb.ShowWatchProvider) -> MoviesDomain.WatchProviderCollection {
        MoviesDomain.WatchProviderCollection(
            id: movieID,
            link: dto.link,
            streamingProviders: dto.flatRate?.map(watchProviderMapper.map) ?? [],
            buyProviders: dto.buy?.map(watchProviderMapper.map) ?? [],
            rentProviders: dto.rent?.map(watchProviderMapper.map) ?? [],
            freeProviders: dto.free?.map(watchProviderMapper.map) ?? []
        )
    }

}
