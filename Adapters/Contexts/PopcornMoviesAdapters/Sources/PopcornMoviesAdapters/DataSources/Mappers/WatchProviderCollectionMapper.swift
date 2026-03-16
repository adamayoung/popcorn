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

    private static let watchProviderMapper = WatchProviderMapper()

    func map(movieID: Int, _ dto: TMDb.ShowWatchProvider) -> MoviesDomain.WatchProviderCollection? {
        guard let link = URL(string: dto.link) else {
            return nil
        }

        return MoviesDomain.WatchProviderCollection(
            id: movieID,
            link: link,
            streamingProviders: dto.flatRate?.map(Self.watchProviderMapper.map) ?? [],
            buyProviders: dto.buy?.map(Self.watchProviderMapper.map) ?? [],
            rentProviders: dto.rent?.map(Self.watchProviderMapper.map) ?? [],
            freeProviders: dto.free?.map(Self.watchProviderMapper.map) ?? []
        )
    }

}
